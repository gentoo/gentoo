# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

inherit vim-plugin ruby-ng

DESCRIPTION="vim plugin: fast file navigation for vim"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=3025 https://github.com/wincent/command-t"
SRC_URI="https://github.com/wincent/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="${PN}.txt"

RDEPEND="|| ( app-editors/vim[ruby] app-editors/gvim[ruby] )"

each_ruby_configure() {
	cd ruby/${PN} || die
	${RUBY} extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	cd ruby/${PN} || die
	emake V=1
	rm *.o *.c *.h *.log extconf.rb depend Makefile || die
}

each_ruby_install() {
	local sitelibdir=$(ruby_rbconfig_value "sitelibdir")
	insinto "${sitelibdir}"
	doins -r ruby/*
}

all_ruby_install() {
	rm Gemfile* *.gemspec Rakefile LICENSE README.md || die
	rm -r appstream bin fixtures data ruby spec vendor || die
	find "${S}" -name .gitignore -delete || die

	vim-plugin_src_install
}
