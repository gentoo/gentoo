config.absolute_base_url = "https://lqfb.example.com/lf"
config.instance_name = "lf"
config.database = { engine='postgresql', dbname='liquid_feedback', user='liquid_feedback', password='xxx'}
config.enable_debug_trace = true

execute.config("init")

config.formatting_engine_executeables = {
  rocketwiki= "rocketwiki-lqfb",
  compat = "rocketwiki-lqfb-compat"
}

-- Checkbox(es) the user has to accept while registering
--
--
----
--------------------------------------------------------------------------
config.use_terms_checkboxes = {
  {
    name = "terms_of_use_v1",
    html = "I accept the terms of use.",
    not_accepted_error = "You have to accept the terms of use to be able to regi ster."
  },
-- {
--    name = "extra_terms_of_use_v1",
--    html = "I accept the extra terms of use.",
--    not_accepted_error = "You have to accept the extra terms of use to be able  to register."
--  }
} 
