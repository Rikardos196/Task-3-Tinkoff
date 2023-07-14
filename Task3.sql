SELECT user_react.user_id
	, user_react.app_id
	, title
	, CASE WHEN negative_date > positive_date THEN TRUE ELSE FALSE END from_positive_to_negative
FROM (SELECT pos_table.app_id
		, pos_table.user_id
		, positive_date
		, pos_table.is_recommended
		, negative_date
		, neg_table.is_recommended
	FROM (SELECT app_id
			, user_id
			, max(date) AS positive_date
			, is_recommended 
		FROM users 
		WHERE is_recommended = TRUE
		GROUP BY app_id
				, user_id
				, is_recommended
		) AS pos_table 
		JOIN (SELECT app_id
				, user_id
				, max(date) AS negative_date
				, is_recommended
			FROM users 
			WHERE is_recommended = false
			GROUP BY app_id, user_id, is_recommended
			) AS neg_table ON pos_table.app_id = neg_table.app_id AND pos_table.user_id = neg_table.user_id
		) AS user_react 
JOIN games ON games.app_id = user_react.app_id
