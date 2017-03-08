# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc RI.rdoc TODO.rdoc"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_BINDIR="exe"

inherit ruby-fakegem eutils

DESCRIPTION="An extended version of the RDoc library from Ruby 1.8"
HOMEPAGE="https://github.com/rdoc/rdoc/"
SRC_URI="https://github.com/rdoc/rdoc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Ruby MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
SLOT="0"
IUSE=""

RDEPEND+=">=app-eselect/eselect-ruby-20161226"

ruby_add_bdepend "
	dev-ruby/kpeg
	dev-ruby/racc
	test? (
		>=dev-ruby/minitest-5.8:5
	)"

ruby_add_rdepend "dev-ruby/json:2"

all_ruby_prepare() {
	# Other packages also have use for a nonexistent directory, bug 321059
	sed -i -e 's#/nonexistent#/nonexistent_rdoc_tests#g' test/test_rdoc*.rb || die

	# Avoid unneeded dependency on bundler, bug 603696
	sed -i -e '/bundler/ s:^:#:' \
		-e 's/Bundler::GemHelper.gemspec.full_name/"rdoc"/' Rakefile || die

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
		ruby -Ilib -S exe/rdoc || die
	fi
}

each_ruby_compile() {
	${RUBY} -S rake generate || die
}

each_ruby_test() {
	${RUBY} -Ilib:. -e 'gem "json", "~>2.0"; Dir["test/test_*.rb"].each{|f| require f}' || die
}

all_ruby_install() {
	all_fakegem_install

	for bin in rdoc ri; do
		ruby_fakegem_binwrapper $bin /usr/bin/$bin-2

		for version in ${USE_RUBY}; do
			version=`echo ${version} | cut -c 5-`
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
