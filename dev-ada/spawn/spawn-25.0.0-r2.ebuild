# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gcc_{12..15} )
inherit ada multiprocessing

DESCRIPTION="Simple API to spawn processes"
HOMEPAGE="https://github.com/AdaCore/spawn"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3 gcc-runtime-library-exception-3.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="static-libs static-pic"
REQUIRED_USE="${ADA_REQUIRED_USE}"

RDEPEND="${ADA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="dev-ada/gprbuild[${ADA_USEDEP}]"

src_compile() {
	build () {
		gprbuild -p -j$(makeopts_jobs) -XBUILD=production -v \
			-XLIBRARY_TYPE=$1 \
			gnat/spawn.gpr -cargs:C ${CFLAGS} -cargs:Ada ${ADAFLAGS} || die
	}
	build relocatable
	use static-libs && build static
	use static-pic  && build static-pic
}

src_test() {
	build () {
		GPR_PROJECT_PATH=gnat \
		gprbuild -p -j$(makeopts_jobs) -XBUILD=production -v \
			-XLIBRARY_TYPE=$1 gnat/tests/spawn_tests.gpr \
			-cargs:C ${CFLAGS} -cargs:Ada ${ADAFLAGS} \
			|| die
	}
	build relocatable
	.obj/spawn_test/spawn_test || die
	.obj/spawn_test/spawn_unexpected || die
	.obj/spawn_test/wait_all || die
	.obj/spawn_test/spawn_bad_exe || die
	.obj/spawn_test/spawn_kill || die
	.obj/spawn_test/spawn_stty || die
}

src_install() {
	build() {
		gprinstall --prefix=/usr --sources-subdir="${D}"/usr/include/spawn \
			-XLIBRARY_TYPE=$1 \
			--lib-subdir="${D}"/usr/$(get_libdir)/spawn \
			--project-subdir="${D}"/usr/share/gpr \
			--link-lib-subdir="${D}"/usr/$(get_libdir)/ -p \
			-P gnat/spawn.gpr || die
	}
	build relocatable
	use static-libs && build static
	use static-pic  && build static-pic
}
