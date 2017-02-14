select 
                     -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ people
                    -- people.id,people.email,people.first_name,people.last_name,people.cellphone,people.google_apps_email,
                     people.work_experience, people.previous_institution, level_of_education.value as highest_level_ed
                     -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ enrol
                     , enrol.person_id,enrol.registration_id, enrol.status,enrol.cancelled_enrolment_reason
                     ,enrol.created_at as enrol_created_at ,enrol.updated_at as enrol_updated_at,
                     enrol.id as enrolment_id
                     -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ address
                     ,address.suburb
                     ,address.city
                     ,address.province
                     ,address.code
                     ,address.country
                     -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ enrol_pres
                     ,enrol_pres.vle_user_id
                     ,enrol.final_mark
                     -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ pres
                     ,pres.vle_course_id
                     ,pres.vle_credential_id
                     ,pres.start_date as phoenix_pres_startdate
                     ,pres.end_date as phoenix_pres_enddate
                     -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ courses
                     -- ,courses.name as phoenix_course_name
                     ,prog_inst.name as phoenix_course_name
                     ,prog_inst.programme_id as prog_inst_prog_id
                     ,prog_inst.code as prog_inst_code
                     -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ vle_cred
                     ,vle_cred.host
                     -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ cancel_reasons
                     ,cancel_reasons.value as cancel_status
                     ,case when cancel_reasons.value  = 'Archive - lack of time' then 'Archive'
                     when cancel_reasons.value  = 'Archive - lack of time' then 'Archive'
                     when cancel_reasons.value  = 'Archive - work related' then 'Archive'
                     when cancel_reasons.value  = 'Archive - work related' then 'Archive'
                     when cancel_reasons.value  = 'Bad debt - other' then 'Bad debt'
                     when cancel_reasons.value  = 'Bad debt - unable to contact' then 'Bad debt'
                     when cancel_reasons.value  = 'Cancellation - Course presentation postponed/cancelled' then 'Cancellation'
                     when cancel_reasons.value  = 'Cancellation - family responsibility/health' then 'Cancellation'
                     when cancel_reasons.value  = 'Cancellation - given misleading information' then 'Cancellation'
                     when cancel_reasons.value  = 'Cancellation - inappropriate subject matter' then 'Cancellation'
                     when cancel_reasons.value  = 'Cancellation - incorrect course topic chosen' then 'Cancellation'
                     when cancel_reasons.value  = 'Cancellation - Student complaint' then 'Cancellation'
                     when cancel_reasons.value  = 'Cancellation - Technical difficulties experienced' then 'Cancellation'
                     when cancel_reasons.value  = 'Cancellation - unable to pay' then 'Cancellation'
                     when cancel_reasons.value  = 'Cancellation - Work related/Lack of time' then 'Cancellation'
                     when cancel_reasons.value  = 'Cancellation (internal) - Duplicate/incorrect registration' then 'Cancellation'
                     when cancel_reasons.value  = 'Deferral - course change (incorrect course topic chosen)' then 'Deferral'
                     when cancel_reasons.value  = 'Deferral - Course presentation postponed' then 'Deferral'
                     when cancel_reasons.value  = 'Deferral - family responsibility/health' then 'Deferral'
                     when cancel_reasons.value  = 'Deferral - unable to pay now' then 'Deferral'
                     when cancel_reasons.value  = 'Deferral - Work related/Lack of time' then 'Deferral'
                     when cancel_reasons.value  = 'Depreciated - deferral' then 'Depreciated'
                     when cancel_reasons.value  = 'Depreciated - lack of finances' then 'Depreciated'
                     when  cancel_reasons.value is null and enrol_status.value = 'Suspended' then 'Suspended'
                     else 'Unknown'
                     end as cancel_status_grp
                     -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ enrol_status
                     ,enrol_status.value as phoenix_status
                     -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                     -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ FROM
                     from people 
                     -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ enrol
                     left join enrolments as enrol
                     on people.id = enrol.person_id
                     -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ address
                     left join addresses as address
                     on people.id = address.person_id
                     and address_type = 1
                     -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ enrol_pres
                     left join enrolment_presentations as enrol_pres
                     on enrol_pres.enrolment_id = enrol.id
                     -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ pres
                     left join presentations as pres
                     on enrol_pres.presentation_id = pres.id
                     -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ prog_inst_pres
                     left join programme_instance_presentations as prog_inst_pres
                     on prog_inst_pres.presentation_id = enrol_pres.presentation_id
                     -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ prog_inst
                     left join programme_instances as prog_inst
                     on prog_inst_pres.programme_instance_id = prog_inst.id
                     -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ cancel_reasons
                     left join enrolments_enum_cancelled_enrolment_reason as cancel_reasons
                     on cancel_reasons.cancelled_enrolment_reason = enrol.cancelled_enrolment_reason
                     -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ courses
                     left join courses as courses
                     on courses.id = pres.course_id
                     and courses.vle_credential_id = pres.vle_credential_id
                     -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ vle_credentials
                     left join vle_credentials as vle_cred
                     on vle_cred.id = pres.vle_credential_id
                     -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ enrol_status
                     left join enrolments_enum_status as enrol_status
                     on enrol_status.`status` = enrol.`status`
                     left join people_enum_highest_level_of_education as level_of_education
                     on people.highest_level_of_education = level_of_education.highest_level_of_education
                     where date(enrol.updated_at) >= '2015-04-01'
                     -- and enrol_status.value in ('Cancelled','Suspended')
                     -- and pres.vle_credential_id = 11
                     and prog_inst.name like '%Web Design%'
                     and year(pres.start_date) = '2016'
                     -- and pres.vle_course_id = 8
                     -- and people.email = 'hansenb@gmail.com'
                     -- and vle_course_id is null
                     order by email
