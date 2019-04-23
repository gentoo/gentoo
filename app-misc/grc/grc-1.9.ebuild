# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5} pypy )

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

PATCHES=(
	# https://github.com/garabik/grc/pull/44
	"${FILESDIR}"/${PN}-1.4-support-more-files.patch
	# https://github.com/garabik/grc/pull/43
	"${FILESDIR}"/${PN}-1.4-ipv6.patch
	# https://github.com/garabik/grc/pull/9
	"${FILESDIR}"/${P}-domain-match.patch
	# https://github.com/garabik/grc/pull/45
	"${FILESDIR}"/${P}-python3.patch
	# https://github.com/garabik/grc/pull/46
	"${FILESDIR}"/${P}-bash.patch
	# https://github.com/garabik/grc/pull/47
	"${FILESDIR}"/${P}-configure.patch
)

src_install() {
	python_foreach_impl python_doscript grc grcat

	insinto /usr/share/grc
	doins \
		mrsmith/conf.* \
		conf.* \
		grc.bashrc

	insinto /etc
	doins grc.conf

	dodoc README INSTALL TODO debian/changelog CREDITS Regexp.txt
	doman *.1
}
