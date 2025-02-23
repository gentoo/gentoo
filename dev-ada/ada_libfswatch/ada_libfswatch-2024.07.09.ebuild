# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gcc_13 gcc_14 )
inherit ada

commitId=838480d8fca344d9f8a78341113ceb4ed5cf2222

DESCRIPTION="Ada binding to the libfswatch library"
HOMEPAGE="https://github.com/AdaCore/ada_libfswatch"
SRC_URI="https://github.com/AdaCore/${PN}/archive/${commitId}.tar.gz
	-> ${P}.tar.gz"

S="${WORKDIR}"/${PN}-${commitId}

LICENSE="GPL-3 gcc-runtime-library-exception-3.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="${ADA_DEPS}
	>=dev-ada/gnatcoll-core-25[${ADA_USEDEP},shared]
	sys-fs/fswatch"
DEPEND="${RDEPEND}"
BDEPEND="dev-ada/gprbuild[${ADA_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${PN}-20201105-link.patch
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
	rm -r "${D}"/usr/share/gpr/manifests
}
