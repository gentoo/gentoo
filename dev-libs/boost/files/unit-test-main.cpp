/*
  A synthetic main() to bootstrap an old-style test suite.
  This seems to be necessary for older tests suites when enforcing
  building against boost as shared library.
  Further details can be found at:
  https://www.boost.org/doc/libs/1_88_0/libs/test/doc/html/boost_test/adv_scenarios/obsolete_init_func.html
*/

bool init_master_suite(void)
{
  test_suite* master = &::boost::unit_test::framework::master_test_suite();
  master->add(init_unit_test_suite(0, nullptr));
  return true;
}

int main(int argc, char* argv[])
{
  return ::boost::unit_test::unit_test_main(init_master_suite, argc, argv);
}
