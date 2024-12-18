# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_PV="${PV/_p/-}"
EGIT_COMMIT="37e382f8960a0cdf639dc9c55314a9b8d0733ead"

DESCRIPTION="Mstflint - an open source version of MFT (Mellanox Firmware Tools)"
HOMEPAGE="https://github.com/Mellanox/mstflint"
SRC_URI="https://github.com/Mellanox/mstflint/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="|| ( GPL-2 BSD-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="adb-generic-tools inband ssl"

DEPEND="
	dev-db/sqlite:3=
	sys-libs/zlib:=
	inband? ( sys-cluster/rdma-core )
	adb-generic-tools? (
		dev-libs/boost:=
		dev-libs/expat:=
	)
	ssl? ( dev-libs/openssl:= )
"
RDEPEND="
	${DEPEND}
	sys-apps/pciutils
"

PATCHES=(
	"${FILESDIR}/mstflint-4.29.0-build-system.patch"
	"${FILESDIR}/mstflint-4.29.0-gcc15.patch"
)

src_prepare() {
	default

	sed -e 's: \*.o: .libs/*.o:' \
		-e 's: tools_dev_types.o: .libs/tools_dev_types.o:' \
		-i cmdif/Makefile.am dev_mgt/Makefile.am reg_access/Makefile.am || die

	sed -e 's:_LDFLAGS = :_LDFLAGS = $(LDFLAGS) :' \
		-i */Makefile.am mstdump/crd_main/Makefile.am || die

	# https://bugs.gentoo.org/939944
	sed -r -e 's:-Werror(=[a-zA-Z0-9-]+|) ::' \
		-i configure.ac ext_libs/json/Makefile.am || die

	printf -- '#define TOOLS_GIT_SHA "%s"' "${EGIT_COMMIT}" > ./common/gitversion.h || die

	eautoreconf
}

src_configure() {
	econf $(use_enable inband) \
		$(use_enable ssl openssl) \
		$(use adb-generic-tools && printf -- '--enable-adb-generic-tools')
}

src_compile() {
	if use adb-generic-tools; then
		pushd ext_libs/json >/dev/null || die
		emake
		popd >/dev/null || die
	fi
	default
}
