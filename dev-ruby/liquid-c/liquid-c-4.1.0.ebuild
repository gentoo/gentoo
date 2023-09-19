# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_TASK_TEST="test:unit"
RUBY_FAKEGEM_EXTRADOC="README.md"

MY_PN=${PN/-/_}
RUBY_FAKEGEM_EXTENSIONS=(ext/${MY_PN}/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="Liquid performance extension in C"
HOMEPAGE="https://github.com/Shopify/liquid-c"

LICENSE="MIT"
SLOT="4"
KEYWORDS="~amd64 ~arm64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/liquid-5.0.1:*"

all_ruby_prepare() {
	sed -i -e "s/-Werror//" ext/${MY_PN}/extconf.rb || die

	sed -i \
		-e "/[Bb]undler/d" \
		-e "/memcheck/Id" \
		-e '/extensiontask/ s:^:#:' \
		Rakefile || die
	sed -i -e 's/unit: :compile/:unit/' rakelib/unit_test.rake || die
	rm -r rakelib/compile.rake || die

	sed -i -e 's/MiniTest/Minitest/' test/unit/*_test.rb || die

	# ruby_memcheck is a gem just for running w/ valgrind.
	# We don't run tests in ebuilds with Valgrind because it's
	# non-portable and sometimes flaky under sandbox.
	rm rakelib/integration_test.rake || die
	sed -i -e '/memcheck/Id' rakelib/unit_test.rake || die
}

each_ruby_test() {
	# Backup the original extension and hide it away
	# The tests won't build if they detect an already-built ext
	mkdir -p "${T}"/${RUBY}.orig || die
	mv ext "${T}"/${RUBY}.orig/ext || die
	cp -r "${WORKDIR}"/all/${P}/ext ext || die

	nonfatal each_fakegem_test --trace || failed_tests=1

	# Always restore the original extension we built, even if
	# tests failed, as FEATURES=test-fail-continue may be enabled.
	rm -rf ext || die
	mv "${T}"/${RUBY}.orig/ext ext || die

	if [[ ${failed_tests} == 1 ]] ; then
		die "Tests failed with ${RUBY}!"
	fi
}
