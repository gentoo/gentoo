# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby31 ruby32 ruby33"

inherit vim-plugin ruby-ng

DESCRIPTION="vim plugin: fast file navigation for vim"
HOMEPAGE="https://vim.sourceforge.io/scripts/script.php?script_id=3025 https://github.com/wincent/command-t"
SRC_URI="https://github.com/wincent/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="${PN}.txt"

RDEPEND="|| ( app-editors/vim[ruby] app-editors/gvim[ruby] )"

all_ruby_prepare() {
	find "${S}" -name .gitignore -delete || die
}

each_ruby_configure() {
	cd ruby/${PN}/ext/${PN} || die
	${RUBY} extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	cd ruby/${PN}/ext/${PN} || die
	emake V=1
	rm *.o *.c *.h *.log extconf.rb depend Makefile || die
}

each_ruby_install() {
	local sitelibdir=$(ruby_rbconfig_value "sitelibdir")
	insinto "${sitelibdir}"
	doins -r ruby/${PN}/{ext,lib}/*
}

all_ruby_install() {
	rm -r appstream bin fixtures data ruby/${PN}/{ext,lib,*.gemspec} spec vendor || die

	vim-plugin_src_install

	# make sure scripts are executable
	chmod +x "${ED}"/usr/share/vim/vimfiles/ruby/${PN}/bin/* || die
}
