# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/andersson/qrtr"
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/andersson/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Userspace reference for net/qrtr in the Linux kernel"
HOMEPAGE="https://github.com/andersson/qrtr"

LICENSE="BSD"
SLOT="0/1.0"	# soname of libqrtr.so
IUSE="gtk-doc"

RDEPEND=""
DEPEND="${RDEPEND}"
BDEPEND=""

src_prepare() {
	sed \
		-e "s:/usr/local:/usr:" \
		-e "s:/lib$:/$(get_libdir):" \
		-i Makefile
	default
}
