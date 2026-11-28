# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/andersson/rmtfs"
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/andersson/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="QMI IDL compiler"
HOMEPAGE="https://github.com/andersson/rmtfs"

LICENSE="BSD"
SLOT="0"

RDEPEND="
	net-libs/libqrtr:=
	virtual/libudev:=
"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/qmic"

src_prepare() {
	sed \
		-e "s:/usr/local:/usr:" \
		-i Makefile
	default
}
