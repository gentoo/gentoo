# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ library for the Linux Sampler control protocol"
HOMEPAGE="https://www.linuxsampler.org"

if [[ ${PV} == "9999" ]] ; then
	inherit subversion
	ESVN_REPO_URI="https://svn.linuxsampler.org/svn/liblscp/trunk"
else
	SRC_URI="https://www.rncbc.org/archive/${P}.tar.gz
		https://download.linuxsampler.org/packages/${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc"

BDEPEND="doc? ( app-text/doxygen )"

PATCHES=(
	"${FILESDIR}/${PN}-0.9.6-conditional.patch"
)

DOCS=( ChangeLog README )

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOC=$(usex doc)
	)
	cmake_src_configure
}
