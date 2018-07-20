# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="ChangeLog README TODO"

RUBY_FAKEGEM_TASK_TEST=""

inherit multilib ruby-fakegem

DESCRIPTION="Ruby binding to libmagic"
HOMEPAGE="https://github.com/blackwinter/ruby-filemagic"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

DEPEND="${DEPEND} sys-apps/file test? ( >=sys-apps/file-5.30 )"
RDEPEND="${RDEPEND} sys-apps/file"

all_ruby_prepare() {
	# Fix up tests for newer sys-apps/file definitions
	sed -i -e '/test_abbrev_mime_type/,/^  end/ s/ms-office/ms-excel/' test/filemagic_test.rb || die

	# Fix up broken test symlink and regenerate compiled magic file
	pushd test || die
	rm -f pylink && ln -s pyfile pylink || die
	file -C -m perl || die
	popd || die
}

each_ruby_configure() {
	${RUBY} -Cext/filemagic extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/filemagic
	mv ext/filemagic/ruby_filemagic$(get_modname) lib/filemagic/ || die
}

each_ruby_test() {
	find test
	${RUBY} -Ctest -I../lib filemagic_test.rb || die
}
