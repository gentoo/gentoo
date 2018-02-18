# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc RI.rdoc TODO.rdoc"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem eutils

DESCRIPTION="An extended version of the RDoc library from Ruby 1.8"
HOMEPAGE="https://github.com/rdoc/rdoc/"

LICENSE="Ruby MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "
	dev-ruby/racc
	test? (
		>=dev-ruby/minitest-5.8:5
	)"

ruby_add_rdepend ">=dev-ruby/json-1.4:0"

all_ruby_prepare() {
	# Other packages also have use for a nonexistent directory, bug 321059
	sed -i -e 's#/nonexistent#/nonexistent_rdoc_tests#g' test/test_rdoc*.rb || die

	# Remove unavailable and unneeded isolate plugin for Hoe
	sed -i -e '/isolate/d' Rakefile || die

	# Remove licenses line from Hoe definitions so we also use older versions.
	sed -i -e '/licenses/ s:^:#:' Rakefile || die

	epatch "${FILESDIR}/${PN}-3.0.1-bin-require.patch"

	# Remove test that is depending on the locale, which we can't garantuee.
	sed -i -e '/def test_encode_with/,/^  end/ s:^:#:' test/test_rdoc_options.rb || die

	# Remove test depending on FEATURES=userpriv, bug 361959
	sed -i -e '/def test_check_files/,/^  end/ s:^:#:' test/test_rdoc_options.rb || die

	# Remove tests for code that is not included and not listed in Manifest.txt
	rm -f test/test_rdoc_i18n_{locale,text}.rb \
	   test/test_rdoc_generator_pot* || die
}

all_ruby_compile() {
	all_fakegem_compile

	if use doc ; then
		ruby -Ilib -S bin/rdoc || die
	fi
}

each_ruby_compile() {
	# Generate the file inline here since the Rakefile confuses jruby
	# into a circular dependency.
	for file in lib/rdoc/rd/block_parser lib/rdoc/rd/inline_parser ; do
		${RUBY} -S racc -l -o ${file}.rb ${file}.ry || die
	done
}

each_ruby_test() {
	${RUBY} -Ilib:. -e 'gem "json", "~>1.4"; Dir["test/test_*.rb"].each{|f| require f}' || die
}

all_ruby_install() {
	all_fakegem_install

	for bin in rdoc ri; do
		ruby_fakegem_binwrapper $bin /usr/bin/$bin-2

		for version in 22 23; do
			if use ruby_targets_ruby${version}; then
				ruby_fakegem_binwrapper $bin /usr/bin/${bin}${version}
				sed -i -e "1s/env ruby/ruby${version}/" \
					"${ED}/usr/bin/${bin}${version}" || die
			fi
		done
	done
}

pkg_postinst() {
	if [[ ! -n $(readlink "${ROOT}"usr/bin/rdoc) ]] ; then
		eselect ruby set $(eselect --brief --colour=no ruby show | head -n1)
	fi
}
