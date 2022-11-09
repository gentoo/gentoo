# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_202{0,1} gcc_12_2_0 )
inherit ada

commitId=94c0a5f137b88113a791a148b60e5e7d019d6fa1

DESCRIPTION="Ada binding to the libfswatch library"
HOMEPAGE="https://github.com/AdaCore/ada_libfswatch"
SRC_URI="https://github.com/AdaCore/${PN}/archive/${commitId}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3 gcc-runtime-library-exception-3.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="${ADA_DEPS}
	dev-ada/gnatcoll-core[${ADA_USEDEP},shared]
	sys-fs/fswatch"
DEPEND="${RDEPEND}"
BDEPEND="dev-ada/gprbuild[${ADA_USEDEP}]"

S="${WORKDIR}"/${PN}-${commitId}

PATCHES=(
	"${FILESDIR}"/${P}-link.patch
)

src_prepare() {
	default
	mkdir -p generated || die
	cp /usr/include/libfswatch/c/* generated || die
	(cd generated && gcc -C -fdump-ada-spec libfswatch.h -D_TIMEZONE_DEFINED) \
		|| die
	rm generated/*h || die
	sed -i \
		-e "1d" \
		ada_libfswatch.gpr || die
}

src_compile() {
	gprbuild -p -v -P ada_libfswatch -XLIBRARY_TYPE=relocatable \
		-cargs:C ${CFLAGS} -cargs:Ada ${ADAFLAGS} \
		|| die
}

src_install() {
	gprinstall -v -r -p -P ada_libfswatch -XLIBRARY_TYPE=relocatable \
		--prefix="${D}"/usr || die
	einstalldocs
}
