# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#PYTHON_COMPAT=( python2_7 )
ADA_COMPAT=( gnat_201{6,7,8,9} gnat_2020 )
#inherit ada multilib multiprocessing python-single-r1
inherit ada multilib multiprocessing

MYP=${PN}-20.0-20191009-1B2EA

DESCRIPTION="GNAT Component Collection"
HOMEPAGE="http://libre.adacore.com"
SRC_URI="https://community.download.adacore.com/v1/3c54db553121bf88877e2f56ac4fca36765186eb?filename=${MYP}-src.tar.gz
	-> ${MYP}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#IUSE="gmp iconv python readline +shared static-libs static-pic syslog"
IUSE="gmp iconv readline +shared static-libs static-pic syslog"

#RDEPEND="python? ( ${PYTHON_DEPS} )
RDEPEND="
	${ADA_DEPS}
	dev-ada/gnatcoll-core[${ADA_USEDEP},shared?,static-libs?,static-pic?]
	gmp? ( dev-libs/gmp:* )"
DEPEND="${RDEPEND}
	dev-ada/gprbuild[${ADA_USEDEP}]"

#REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )
REQUIRED_USE="
	${ADA_REQUIRED_USE}"

S="${WORKDIR}"/${MYP}-src

pkg_setup() {
#	use python && python-single-r1_pkg_setup
	ada_pkg_setup
}

src_compile() {
	build () {
		gprbuild -j$(makeopts_jobs) -m -p -v \
			-XGPR_BUILD=$2 -XGNATCOLL_CORE_BUILD=$2 \
			-XLIBRARY_TYPE=$2 -P $1/gnatcoll_$1.gpr -XBUILD="PROD" \
			-XGNATCOLL_ICONV_OPT= \
			-cargs:Ada ${ADAFLAGS} -cargs:C ${CFLAGS} || die "gprbuild failed"
#			-XGNATCOLL_ICONV_OPT= -XGNATCOLL_PYTHON_CFLAGS="-I$(python_get_includedir)" \
#			-XGNATCOLL_PYTHON_LIBS=$(python_get_library_path) \
	}
	for kind in shared static-libs static-pic ; do
		if use $kind; then
			lib=${kind%-libs}
			lib=${lib/shared/relocatable}
#			for dir in gmp iconv python readline syslog ; do
			for dir in gmp iconv readline syslog ; do
				if use $dir; then
					build $dir $lib
				fi
			done
		fi
	done
}

src_install() {
	build () {
		gprinstall -p -f -XBUILD=PROD --prefix="${D}"/usr -XLIBRARY_TYPE=$2 \
			-XGPR_BUILD=$2 -XGNATCOLL_CORE_BUILD=$2 \
			-XGNATCOLL_ICONV_OPT= -P $1/gnatcoll_$1.gpr --build-name=$2
	}
	for kind in shared static-libs static-pic ; do
		if use $kind; then
			lib=${kind%-libs}
			lib=${lib/shared/relocatable}
#			for dir in gmp iconv python readline syslog ; do
			for dir in gmp iconv readline syslog ; do
				if use $dir; then
					build $dir $lib
				fi
			done
		fi
	done
	if use iconv; then
		sed -i \
			-e "s:GNATCOLL_ICONV_BUILD:LIBRARY_TYPE:" \
			"${D}"/usr/share/gpr/gnatcoll_iconv.gpr \
			|| die
	fi
	rm -r "${D}"/usr/share/gpr/manifests || die
	einstalldocs
}
