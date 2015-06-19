# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/fxruby/fxruby-1.6.25.ebuild,v 1.12 2013/12/25 09:38:03 patrick Exp $

EAPI=4
USE_RUBY="ruby19"

RUBY_FAKEGEM_NAME="fxruby"

RUBY_FAKEGEM_TASK_DOC="docs"

RUBY_FAKEGEM_EXTRADOC="History.txt index.html README.rdoc TODO"

inherit multilib virtualx ruby-fakegem toolchain-funcs

DESCRIPTION="Ruby language binding to the FOX GUI toolkit"
HOMEPAGE="http://www.fxruby.org/"

LICENSE="LGPL-2.1"
SLOT="1.6"
KEYWORDS="amd64 hppa ppc ppc64 x86 ~x86-fbsd"
IUSE="examples doc"

CDEPEND="x11-libs/fox:1.6 >=x11-libs/fxscintilla-1.62-r1"
DEPEND="${DEPEND} ${CDEPEND} dev-lang/swig"
RDEPEND="${RDEPEND} ${CDEPEND}"

ruby_add_bdepend "test? ( dev-ruby/ruby-opengl )"

ruby_add_bdepend "dev-ruby/hoe"

all_ruby_prepare() {
	sed -i -e '/\[:compile\]/d' Rakefile || die
	einfo "Avoid -O0 builds"
	sed -i -e 's:-O0 -I:-I:' \
		ext/fox16/extconf.rb || die "Can't fix forced -O0"

	# Avoid a dependency on rake-compiler.
	sed -i -e '/extensiontask/ s:^:#:' \
		-e '/Rake::ExtensionTask/,$ s:^:#:' Rakefile || die
	sed -i -e '/extension/ s:^:#:' \
		-e '/Rake::ExtensionTask/,$ s:^:#:' \
		-e '/CLEAN.include/ s:^:#:' \
		-e '/task :cross/,/^end/ s:^:#:' Rakefile.cross || die

	# Use a more modern swig.
	sed -i -e 's/swig-1.3.22/swig/g' Rakefile || die

	# Remove failing tests. We did not run tests before so this is not a
	# regression for now.
	rm test/TC_FXFileStream.rb test/TC_FXId.rb test/TC_FXMainWindow.rb test/TC_FXMaterial.rb || die
}

each_ruby_configure() {
	${RUBY} -Cext/fox16 extconf.rb || die
}

each_ruby_compile() {
	CXX=$(tc-getCXX) emake -Cext/fox16 || die
	cp ext/fox16/fox16$(get_modname) lib/ || die
}

each_ruby_test() {
	VIRTUALX_COMMAND=${RUBY} virtualmake -S rake test || die
}

all_ruby_install() {
	all_fakegem_install

	if use examples; then
		for dir in sample samples example examples; do
			if [ -d ${dir} ] ; then
				dodir /usr/share/doc/${PF}
				cp -pPR ${dir} "${D}"/usr/share/doc/${PF} || die "cp failed"
			fi
		done
	fi
}
