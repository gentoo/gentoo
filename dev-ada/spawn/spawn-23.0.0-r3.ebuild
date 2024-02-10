# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gnat_2021 gcc_12 gcc_13 )
inherit ada multiprocessing

DESCRIPTION="Simple API to spawn processes"
HOMEPAGE="https://github.com/AdaCore/spawn"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3 gcc-runtime-library-exception-3.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="glib +shared static-libs static-pic"
REQUIRED_USE="|| ( shared static-libs static-pic )
	${ADA_REQUIRED_USE}"

RDEPEND="${ADA_DEPS}
	glib? (
	dev-ada/gtkada[${ADA_USEDEP},shared?,static-libs?,static-pic(-)?]
	dev-libs/glib
)"
DEPEND="${RDEPEND}"
BDEPEND="dev-ada/gprbuild[${ADA_USEDEP}]"

src_compile() {
	build () {
		gprbuild -p -j$(makeopts_jobs) -XBUILD=production -v \
			-XLIBRARY_TYPE=$1 \
			gnat/spawn.gpr -cargs:C ${CFLAGS} -cargs:Ada ${ADAFLAGS} || die
		if use glib; then
			gprbuild -p -j$(makeopts_jobs) -XBUILD=production -v \
				-XLIBRARY_TYPE=$1 \
				gnat/spawn_glib.gpr -cargs:C ${CFLAGS} -cargs:Ada ${ADAFLAGS} \
				|| die
		fi
	}
	if use shared; then
		build relocatable
	fi
	if use static-libs; then
		build static
	fi
	if use static-pic; then
		build static-pic
	fi
}

src_test() {
	build () {
		gprbuild -p -j$(makeopts_jobs) -XBUILD=production -v \
			-XLIBRARY_TYPE=$1 \
			gnat/spawn_tests.gpr -cargs:C ${CFLAGS} -cargs:Ada ${ADAFLAGS} \
			|| die
		if use glib; then
			gprbuild -p -j$(makeopts_jobs) -XBUILD=production -v \
				-XLIBRARY_TYPE=$1 \
				gnat/spawn_glib_tests.gpr \
				-cargs:C ${CFLAGS} -cargs:Ada ${ADAFLAGS} || die
		fi
	}
	if use shared; then
		build relocatable
	elif use static-libs; then
		build static
	elif use static-pic; then
		build static-pic
	fi
	.obj/spawn_test/spawn_test || die
	.obj/spawn_test/spawn_unexpected || die
	.obj/spawn_test/spawn_kill || die
	if use glib; then
		.obj/spawn_test/spawn_glib_test || die
		.obj/spawn_test/spawn_glib_args_test.exe || die
	fi
}

src_install() {
	build() {
		gprinstall --prefix=/usr --sources-subdir="${D}"/usr/include/spawn \
			-XLIBRARY_TYPE=$1 \
			--lib-subdir="${D}"/usr/lib/spawn \
			--project-subdir="${D}"/usr/share/gpr \
			--link-lib-subdir="${D}"/usr/lib/ -p \
			-P gnat/spawn.gpr || die
		if use glib; then
			gprinstall --prefix=/usr \
				-XLIBRARY_TYPE=$1 \
				--sources-subdir="${D}"/usr/include/spawn_glib \
				--lib-subdir="${D}"/usr/lib/spawn_glib \
				--project-subdir="${D}"/usr/share/gpr \
				--link-lib-subdir="${D}"/usr/lib/ -p \
				-P gnat/spawn_glib.gpr || die
		fi
	}
	if use shared; then
		build relocatable
	fi
	if use static-libs; then
		build static
	fi
	if use static-pic; then
		build static-pic
	fi
}
