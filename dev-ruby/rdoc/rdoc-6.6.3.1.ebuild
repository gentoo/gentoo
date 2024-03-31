# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_DOC=""
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc RI.rdoc TODO.rdoc"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_BINDIR="exe"

RUBY_FAKEGEM_GEMSPEC="rdoc.gemspec"

inherit ruby-fakegem

DESCRIPTION="An extended version of the RDoc library from Ruby 1.8"
HOMEPAGE="https://github.com/ruby/rdoc/"
SRC_URI="https://github.com/ruby/rdoc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-2 Ruby-BSD )"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
SLOT="0"
IUSE="doc"

RDEPEND+=">=app-eselect/eselect-ruby-20181225"

ruby_add_rdepend "
	>=dev-ruby/psych-4.0.0
"

ruby_add_bdepend "
	>=dev-ruby/kpeg-1.1.0-r1
	>dev-ruby/racc-1.4.10
	dev-ruby/rake
	test? (
		dev-ruby/bundler
		>=dev-ruby/minitest-5.8:5
	)"

all_ruby_prepare() {
	# Other packages also have use for a nonexistent directory, bug 321059
	sed -i -e 's#/nonexistent#/nonexistent_rdoc_tests#g' test/rdoc/test_rdoc*.rb || die

	# Avoid unneeded dependency on bundler, bug 603696
	sed -i -e '/bundler/ s:^:#:' \
		-e 's/Bundler::GemHelper.gemspec.full_name/"rdoc"/' \
		-e '/rubocop\/rake/ s:^:#:' \
		-e '/RuboCop/,/end/ s:^:#:' Rakefile || die

	# Skip rubygems tests since the rubygems test case code is no longer installed by rubygems.
	sed -i -e '/^task/ s/, :rubygems_test//' Rakefile || die

	# Remove test that is depending on the locale, which we can't garantuee.
	sed -i -e '/def test_encode_with/,/^  end/ s:^:#:' test/rdoc/test_rdoc_options.rb || die

	# Remove test depending on FEATURES=userpriv, bug 361959
	sed -i -e '/def test_check_files/,/^  end/ s:^:#:' test/rdoc/test_rdoc_options.rb || die

	sed -i -e 's:_relative ": "./:' ${RUBY_FAKEGEM_GEMSPEC} || die
}

all_ruby_compile() {
	all_fakegem_compile

	if use doc ; then
		ruby -S exe/rdoc --force-output || die
		rm -f doc/js/*.gz || die
	fi
}

each_ruby_compile() {
	LANG=C.UTF-8 ${RUBY} -S rake generate || die
}

all_ruby_install() {
	all_fakegem_install

	for bin in rdoc ri; do
		ruby_fakegem_binwrapper $bin /usr/bin/$bin-2

		for version in $(ruby_get_use_implementations); do
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
	if [[ ! -n $(readlink "${ROOT}"/usr/bin/rdoc) ]] ; then
		eselect ruby set $(eselect --brief --colour=no ruby show | head -n1)
	fi
}
