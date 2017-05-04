# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} pypy )

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
		colourfiles/conf.*
	insinto /etc/profile.d
	newins grc.bashrc grc.sh

	insinto /etc
	doins grc.conf

	dodoc README.markdown INSTALL TODO debian/changelog CREDITS Regexp.txt
	doman *.1
}
