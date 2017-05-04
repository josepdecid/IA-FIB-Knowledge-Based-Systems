; Thu May 04 17:12:47 CEST 2017
; 
;+ (version "3.5")
;+ (build "Build 663")

;%%%%%
;%
;% Classes
;%
;%%%%%

(load rico_rico.pont)

;%%%%%
;%
;% INSTANCES
;%
;%%%%%

(load rico_rico.pins)

;%%%%%
;%
;% DEFINITIONS
;%
;%%%%%

(defglobal
	?*EVENT_TYPES* = (create$ Familiar Congress)
	?*DRINK_TYPES* = (create$ Alcohol Soft-drinks Caffeine Juice none)
	?*CUISINE_STYLES* = (create$ Vegetarian Spanish Italian French Chinese Japanese Turkish American Mexican Indian Moroccan Gourmet Mediterranean none)
	?*DIETARY_RESTRICTIONS* = (create$ Gluten-free Vegan Vegetarian Lactose-free Kosher Islamic none)
)

;%%%%%
;%
;% FUNCTIONS
;%
;%%%%%

(deffunction ask-question-opt (?question ?allowed-values)
  (printout t "| > " ?question ?allowed-values crlf "| ")
  (bind ?answer (read))
  (while (not (member ?answer ?allowed-values)) do
    (printout t "| > "?question)
    (bind ?answer (read))
	)
  ?answer
)

(deffunction ask-question-yes-no (?question)
	(printout t "| > " ?question crlf "| ")
	(bind ?answer (read))
	(bind ?allowed-values (create$ Yes No yes no Y N y n))
	(while (not (member ?answer ?allowed-values)) do
		(printout t "| > " ?question)
		(bind ?answer (read))
	)
  (if (or (eq ?answer Yes) (eq ?answer yes) (eq ?answer Y) (eq ?answer y)) then
		TRUE
  else
		FALSE
	)
)

(deffunction ask-question-multi-opt (?question ?allowed-values)
	(printout t "| > " ?question ?allowed-values crlf "| ")
	(bind ?line (readline))
	(bind $?answer (explode$ ?line))
  (bind ?valid FALSE)
  (while (not ?valid) do
    (loop-for-count (?i 1 (length$ $?answer)) do
      (bind ?valid FALSE)
      (bind ?value-belongs FALSE)
      (loop-for-count (?j 1 (length$ $?allowed-values)) do
        (if (eq (nth$ ?i $?answer) (nth$ ?j $?allowed-values)) then
        	(bind ?value-belongs TRUE)
          (break)
        )
      )
      (if (not ?value-belongs) then
        (printout t "| " (nth$ ?i $?answer) " is not a valid option" crlf)
        (break)
      )
      (bind ?valid TRUE)
    )
    (if ?valid then (break))

    (printout t "| > " ?question crlf)
    (bind ?line (readline))
    (bind $?answer (explode$ ?line))
  )
  $?answer
)

(deffunction is-num (?num)
  (bind ?ret (or (eq (type ?num) INTEGER) (eq (type ?num) FLOAT))) ?ret
)

(deffunction ask-question-num (?question ?min ?max)
  (printout t "| > " ?question)
  (bind ?answer (read))
  (while (not (and (is-num ?answer) (>= ?answer ?min) (<= ?answer ?max))) do
    (printout t "| " ?question)
  	(bind ?answer (read)))
  ?answer
)

(deffunction collection-contains-all-elements (?all-elements ?collection)
	(loop-for-count (?i 1 (length$ ?all-elements)) do
		(bind ?found FALSE)
		(loop-for-count (?j 1 (length ?collection)) do
			(if (eq (nth$ ?i ?all-elements) (nth$ ?j ?collection)) then
				(bind ?found TRUE)
				(break)
			)
		)
		(if (not ?found) then
			(return FALSE)
		)
	)
	TRUE
)

(deffunction combinate-possible-dishes(?price-min ?price-max ?dishes)
	42
)

(deffunction calculate-price-dishes ($?elements)
	(bind ?price 0.0)
	(loop-for-count (?i 1 (length$ ?elements))
		(bind ?price (+ ?price (send (nth$ ?i ?elements) get-dish-price)))
	)
	?price
)

(deffunction get-minimum-menu-price (?menus)
	(bind ?min-index 1)
	(loop-for-count (?i 2 (length$ ?menus)) do
		(if (< (send (nth$ ?i ?menus) get-menu-price) (send (nth$ ?min-index ?menus) get-menu-price)) then
			(bind ?min-index ?i)
		)
	)
	(nth$ ?min-index ?menus)
)

(deffunction get-maximum-menu-price (?menus)
	(bind ?max-index 1)
	(loop-for-count (?i 2 (length$ ?menus)) do
		(if (> (send (nth$ ?i ?menus) get-menu-price) (send (nth$ ?max-index ?menus) get-menu-price)) then
			(bind ?max-index ?i)
		)
	)
	(nth$ ?max-index ?menus)
)

(deffunction print-dishes (?dishes)
  (loop-for-count (?i 1 (length$ ?dishes)) do
    (printout t "| - Name: " (send (nth$ ?i ?dishes) get-dish-name) "." crlf)
    (printout t "| - Ingredients: " (send (nth$ ?i ?dishes) get-dish-ingredients) "." crlf)
    (printout t "| - Price: " (send (nth$ ?i ?dishes) get-dish-price) "." crlf)
  )
)

(deffunction print-menu (?menu ?header)
	(printout t "*---------------------------------------------------" crlf)
	(printout t "| " ?header crlf)
  (printout t "|---------------------------------------------------" crlf)
  (printout t "| Main course - " (send (send ?menu get-main-course) get-dish-name) "." crlf)
  (printout t "| Second course - " (send (send ?menu get-second-course) get-dish-name) "." crlf)
  (printout t "| Dessert - " (send (send ?menu get-dessert) get-dish-name) "." crlf)
  (printout t "| Drink - " (send (send ?menu get-menu-drink) get-drink-name) "." crlf)
	(printout t "| Price - " (send ?menu get-menu-price) "€" crlf)
  (printout t "*---------------------------------------------------" crlf)
)

;%%%%%
;%
;% DETERMINE USER RULES
;%
;%%%%%

(defrule print-welcome-message "Initial program message"
  (declare (salience 0))
  =>
  (printout t "*-------------------------------------------------------------------------------------" crlf)
  (printout t "|                                                               ___          /|      |" crlf)
  (printout t "|     * Eric Dacal                                 ||||     .-''   ''-.     } |      |" crlf)
  (printout t "|     * Josep de Cid                          |||| ||||   .'  .-'`'-.  '.   } | /  \\ |" crlf)
  (printout t "|     * Joaquim Marset                        |||| \\  /  /  .'       '.  \\  } | |()| |" crlf)
  (printout t "|                                             \\  /  ||  /  :           :  \\  \\| \\  / |" crlf)
  (printout t "|                Welcome to                    ||   ||  | :             : |  ||  ||  |" crlf)
  (printout t "|     _____                _____               %%   %%  | :             : |  %%  %%  |" crlf)
  (printout t "|   (, /   ) ,           (, /   ) ,            %%   %%  \\  :           :  /  %%  %%  |" crlf)
  (printout t "|     /__ /    _  _        /__ /    _  _       %%   %%   \\  '.       .'  /   %%  %%  |" crlf)
  (printout t "|  ) /   \\__(_(__(_)    ) /   \\__(_(__(_)      %%   %%    '.  `-.,.-'  .'    %%  %%  |" crlf)
  (printout t "| (_/                  (_/                     %%   %%      '-.,___,.-'      %%  %%  |" crlf)
  (printout t "*-------------------------------------------------------------------------------------" crlf "|" crlf)
)

(defrule determine-event-type "Asks for event type"
	(declare (salience -1))
	(not (event event-type ?))
	=>
	(bind ?type (ask-question-opt "Which type of event will it be? " ?*EVENT_TYPES*))
	(assert (event event-type ?type))
)

(defrule determine-event-date "Asks for dates"
  (declare (salience -2))
  (not (event date ?))
  (not (event month ?))
  (not (event hour ?))
  =>
  (printout t "| Tell me event date " crlf)
  (bind ?day (ask-question-num "Day? " 1 31))
  (bind ?month (ask-question-num "Month? " 1 12))
  (bind ?hour (ask-question-num "Hour? " 0 24))
  (assert (event day ?day))
  (assert (event month ?month))
  (assert (event hour ?hour))
)

(defrule determine-event-guests "Asks for number of assistants"
  (declare (salience -3))
  (not (event guests ?))
  =>
  (bind ?guests (ask-question-num "Number of guests? " 1 10000))
  (assert (event guests ?guests))
)

(defrule determine-preferred-cuisine-styles "Asks for preferred cuisine styles"
  (declare (salience -4))
  (not (event preferred-cuisine-styles $?))
  =>
  (bind $?styles (ask-question-multi-opt "Which cuisine styles do you prefer? " ?*CUISINE_STYLES*))
  (assert (event preferred-cuisine-styles $?styles))
)

(defrule determine-dietary-restrictions "Asks for dietary restrictions"
  (declare (salience -5))
  (not (event dietary-restrictions $?))
  =>
  (bind $?restrictions (ask-question-multi-opt "Any dietary restrictions? " ?*DIETARY_RESTRICTIONS*))
	(assert (event dietary-restrictions ?restrictions))
)

(defrule determine-drinks "Asks for banned drinks and if one drink per dish is required"
	(declare (salience -6))
	(not (or (event drink-per-dish $?) (event drink-types $?)))
	=>
	(bind ?drink-per-dish (ask-question-yes-no "Will you require a drink for each dish? "))
	(bind ?drink-types (ask-question-multi-opt "Would you discard any drinks? " ?*DRINK_TYPES*))
	(assert (event drink-per-dish ?drink-per-dish))
	(assert (event drink-types ?drink-types))
)

(defrule determine-price-range "Asks for event menu price range"
	(declare (salience -7))
	(not (or (event price_min ?) (event price_max ?)))
  =>
  (while TRUE do
		(bind ?price_min (ask-question-num "Minimum price to pay? " 0 10000))
    (bind ?price_max (ask-question-num "Maximum price to pay? " 0 10000))
    (if (>= ?price_max ?price_min) then (break))
    (printout t "| Maximum price must be greater than minimum price" crlf)
  )
  (assert (event price_min ?price_min))
  (assert (event price_max ?price_max))
  (assert (event ready TRUE))
)

;%%%%%
;%
;% RECOMENDATION RULES
;%
;%%%%%

(defrule get-possible-main-courses ""
  (event ready ?)
	(event preferred-cuisine-styles $?preferences)
  (event dietary-restrictions $?restrictions)
	=>
	(bind ?main-courses (find-all-instances ((?ins MainCourse))
	(and
    ; Filter non-desired food types
    (or (eq ?preferences (create$ none)) (collection-contains-all-elements ?preferences ?ins:dish-classification))
    ; Filter banned options
    (or (eq ?restrictions (create$ none)) (not (collection-contains-all-elements ?restrictions ?ins:dish-classification)))
  )))
	(assert (main-courses ready ?main-courses)
)

(defrule get-possible-second-courses ""
  (event ready ?)
	(event preferred-cuisine-styles $?preferences)
  (event dietary-restrictions $?restrictions)
	=>
	(bind ?second-courses (find-all-instances ((?ins SecondCourse))
	(and
    ; Filter non-desired food types
    (or (eq ?preferences (create$ none)) (collection-contains-all-elements ?preferences ?ins:dish-classification))
    ; Filter banned options
    (or (eq ?restrictions (create$ none)) (not (collection-contains-all-elements ?restrictions ?ins:dish-classification)))
  )))
	(assert (second-courses ready ?second-courses)
)

(defrule get-possible-desserts ""
  (event ready ?)
	(event preferred-cuisine-styles $?preferences)
  (event dietary-restrictions $?restrictions)
	=>
	(bind ?desserts (find-all-instances ((?ins Dessert))
	(and
    ; Filter non-desired food types
    (or (eq ?preferences (create$ none)) (collection-contains-all-elements ?preferences ?ins:dish-classification))
    ; Filter banned options
    (or (eq ?restrictions (create$ none)) (not (collection-contains-all-elements ?restrictions ?ins:dish-classification)))
  )))
	(assert (desserts ready ?desserts)
)

(defrule generate-menu-combinations "Generates different menu combinations"
	(event price_min ?price-min)
	(event price_max ?price-max)
	(main-courses ready $?main-courses)
	(second-courses ready $?second-courses)
	(desserts ready $?desserts)
	=>
	(bind ?drinks (find-all-instances ((?ins Drink)) TRUE))
	(bind ?menus (create$))
	(loop-for-count (?i 1 (length$ ?main-courses)) do ; Main course
		(loop-for-count (?j 1 (length$ ?second-courses)) do ; Second course
			(if (are-different-combine (nth$ ?i ?main-courses) (nth$ ?j ?second-courses)) then
				(loop-for-count (?k 1 (length$ ?dishes)) do ; Desert
					(if (and (not (eq ?j ?k)) (member$ Dessert (send (nth$ ?k ?dishes) get-dish-type))) then
						(bind ?drink-index (+ (mod (random) (length$ ?drinks)) 1))
						(bind ?ins
							(make-instance (gensym) of Menu
								(main-course (nth$ ?i ?dishes))
								(second-course (nth$ ?j ?dishes))
								(dessert (nth$ ?k ?dishes))
								(menu-drink (nth$ ?drink-index ?drinks))
								(menu-price (+ (send (nth$ ?drink-index ?drinks) get-drink-price)
									(calculate-price-dishes (nth$ ?i ?dishes) (nth$ ?j ?dishes) (nth$ ?k ?dishes)))
								)
							)
						)
						(if (and (<= ?price_min (send ?ins get-menu-price)) (>= ?price_max (send ?ins get-menu-price))) then
							(bind ?menus (insert$ ?menus (+ (length$ ?menus) 1) ?ins))
						)
					)
				)
			)
		)
	)
	(assert (generated-menus ready ?menus))
)

(defrule generate-low-price-menu ""
	(generated-menus ready $?menus)
	=>
	(assert (low-menu ready (get-minimum-menu-price ?menus)))
)

(defrule generate-medium-price-menu ""
	(generated-menus ready $?menus)
	=>
	(assert (medium-menu ready (nth (+ (mod (random) (length$ ?menus)) 1) ?menus)))
)

(defrule generate-high-price-menu ""
	(generated-menus ready $?menus)
	=>
	(assert (high-menu ready (get-maximum-menu-price ?menus)))
)

(defrule print-recomendations ""
	(low-menu ready ?low-menu)
	(medium-menu ready ?medium-menu)
	(high-menu ready ?high-menu)
	=>
	(print-menu ?low-menu "Cheap menu")
	(print-menu ?medium-menu "Normal menu")
	(print-menu ?high-menu "Expensive menu")
)
