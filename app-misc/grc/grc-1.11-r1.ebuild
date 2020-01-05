# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit eutils python-r1

DESCRIPTION="Generic Colouriser beautifies your logfiles or output of commands"
HOMEPAGE="http://kassiopeia.juls.savba.sk/~garabik/software/grc.html"
SRC_URI="https://github.com/garabik/grc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

src_prepare() {
	sed \
		-e 's:#! :#!:g' \
		-e 's:3$::g' \
		-i grc grcat || die
	default
}

src_install() {
	python_foreach_impl python_doscript grc grcat

	insinto /usr/share/grc
	doins \
		contrib/mrsmith/conf.* \
		colourfiles/conf.* \
		grc.bashrc \
		grc.fish \
		grc.zsh

	insinto /etc
	doins grc.conf

	dodoc README.markdown INSTALL TODO debian/changelog CREDITS Regexp.txt
	doman *.1
}

pkg_postinst() {
	elog
	elog "Shell specific configurations can be found in ${ROOT}usr/share/grc"
	elog "Be sure to symlink one to use grc globally:"
	elog
	elog "    ln -s ${ROOT}usr/share/grc.SHELL ${ROOT}etc/profile.d/grc.sh"
	elog
	elog "Replace 'SHELL' in the above command with one of: bashrc, fish, zsh."
	elog "Afterwards, use '. ${ROOT}etc/profile' to activate grc in existing"
	elog "shell sessions."
	elog
}
