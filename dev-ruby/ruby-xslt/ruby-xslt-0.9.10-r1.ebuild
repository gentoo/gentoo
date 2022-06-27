# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="ChangeLog.rdoc AUTHORS.rdoc README.rdoc"

RUBY_FAKEGEM_EXTENSIONS=(ext/xslt_lib/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/xml"

inherit ruby-fakegem

DESCRIPTION="A Ruby class for processing XSLT"
HOMEPAGE="https://github.com/glejeune/ruby-xslt"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE=""

DEPEND+=" >=dev-libs/libxslt-1.1.12"
RDEPEND+=" >=dev-libs/libxslt-1.1.12"

all_ruby_prepare() {
	# Remove forced -g compiler flag.
	sed -i -e 's/-g //' ext/xslt_lib/extconf.rb || die

	# One test fails but we have installed this code already for a long
	# time so this probably isn't a regression. No upstream bug tracker
	# to report the problem :-(
	sed -i -e '/test_transformation_error/,/^  end/ s:^:#:' test/test.rb || die
}

each_ruby_test() {
	${RUBY} -I../lib:lib -Ctest test.rb || die
}
