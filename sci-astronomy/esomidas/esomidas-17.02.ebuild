# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils fortran-2 toolchain-funcs flag-o-matic

# MIDVERS is actually used by MIDAS configuration scripts
export MIDVERS="17FEBpl1.2"

DESCRIPTION="European Southern Observatory Munich Image Data Analysis System"
HOMEPAGE="http://www.eso.org/projects/esomidas/"
SRC_URI="ftp://ftp.eso.org/pub/midaspub/17FEB/sources/${MIDVERS}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/8"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND="
	sys-libs/readline:0=
	x11-libs/motif:0=
	x11-libs/libX11:=
	x11-libs/libXt:="
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MIDVERS}"

PATCHES=(
	"${FILESDIR}/${P}-output_to_stdout.patch"
	"${FILESDIR}/${P}-gentoo-setup.patch"
)

src_prepare() {
	default
	# variables for all phases and midas internal build system
	export MIDASHOME="${WORKDIR}"
	export MID_HOME="${S}"
	export MID_HOME0="/usr/$(get_libdir)/esomidas/${MIDVERS}"
	export MID_INSTALL="${MID_HOME}/install/unix"
	export MID_SYS="${MID_HOME}/system/unix/"
	export MID_WORK="${MIDASHOME}/midwork"

	# create a gentoo option file
	mkdir ${MID_INSTALL}/systems/Gentoo || die
	cat >> ${MID_INSTALL}/systems/Gentoo/make_options <<-EOF
		CC=$(tc-getCC)
		LDCC=$(tc-getCC)
		F77=$(tc-getFC)
		FC=$(tc-getFC)
		LD77_CMD=$(tc-getFC)
		AR=$(tc-getAR)
		RANLIB=$(tc-getRANLIB)
		F_OPT=
		C_OPT=
		E_OPT=$(use amd64 && echo -Z)
		SYS=
		SH_OPT=-fPIC
		SH_CMD=${MIDASHOME}/${MIDVERS}/local/make_shared
		GUI_OPT=-DPATH_MAX=1024
		STRIP=echo
		EDITFLAGS=-DVOID_SIGHANDLER -DHAVE_ALLOCA -DHAVE_ALLOCA_H -DHAVE_GETPW_DECLS -DHAVE_DIRENT_H -DHAVE_STRING_H -DLinux -DHAVE_UNISTD_H -DHAVE_STDLIB_H
		EDITLIBS=-lreadline
		UIMX=uimxR5
		INSTALL_FLAG=auto
	EOF
	sed -e "s|gcc|$(tc-getCC) \${LDFLAGS}|" \
		${MID_INSTALL}/systems/Linux/make_shared \
		> ${MID_INSTALL}/systems/Gentoo/make_shared || die
	sed -e 's|PC/Linux|Gentoo|' \
		${MID_INSTALL}/systems/Linux/setup \
		> ${MID_INSTALL}/systems/Gentoo/setup || die

	# gentoo readline avoids exporting the xmalloc,xrealloc and xfree
	append-cppflags -Dxrealloc=_rl_realloc -Dxmalloc=_rl_malloc -Dxfree=_rl_free
}

src_configure() {
	${MID_INSTALL}/select all || die "packages selection failed"
	${MID_INSTALL}/preinstall -a || die "preinstallation failed"
	${MID_INSTALL}/install2 || die "configuration failed"
	chmod 755 ${MID_HOME}/local/make_shared
}

src_compile() {
	CMND_YES=2 ${MID_INSTALL}/install3 -a || die "compilation failed"
	[[ -x ${MID_HOME}/monit/midasgo.exe ]] || die "somewhere compilation failed"
	emake -C monit syskeys.unix
	${MID_SYS}/inmidas -m ${MID_WORK} -j "@ compile.all"
	${MID_SYS}/inmidas -m ${MID_WORK} -j "@ ascii_bin no ; bye"
}

src_test() {
	local test_dir="${WORKDIR}/test_tmp"
	mkdir ${test_dir} && cd ${test_dir}
	${MID_SYS}/inmidas -m ${MID_WORK} -j "@ vericopy ; @@ veriall -nodisplay ; bye" || die
	test -f ${MID_WORK}/veriall_* || die "tests failed somewhere"
	rm -rf ${test_dir}
}

src_install() {
	yes | ${MID_SYS}/cleanmidas
	find ${MID_HOME} \( \
		-name "*.a" -o \
		-name "makefile" -o \
		-name "default.mk" -o \
		-name "*.h" -o \
		-name "*.inc" -o \
		-name COPYING -o \
		-name "*~" -o \
		-name "*.mod" \) -delete
	rm -rf ${MID_HOME}/libsrc/ftoc*
	find ${MID_HOME} -type d -empty -delete

	sed -e "s:^MIDVERS0=.*:MIDVERS0=${MIDVERS}:" \
		-e "s:^MIDASHOME0=.*:MIDASHOME0=/usr/$(get_libdir)/esomidas:" \
		-i ${MID_HOME}/system/unix/{inmidas,helpmidas,drs}

	cd "${WORKDIR}"
	dodir /usr/$(get_libdir)/esomidas
	mv "${S}" "${ED}"${MID_HOME0}
	chmod 0644 "${ED}"${MID_HOME0}/contrib/baches/*/*.fit \
			   "${ED}"${MID_HOME0}/contrib/baches/*/*.fmt \
			   "${ED}"${MID_HOME0}/contrib/baches/*/*.datorg \
			   "${ED}"${MID_HOME0}/contrib/baches/*/*.prg \
			   "${ED}"${MID_HOME0}/contrib/baches/*/*.README
	find "${ED}"${MID_HOME0} -name \*.sh | xargs chmod 0755
	chmod 0755 "${ED}"${MID_HOME0}/util/bench/brun

	dosym ${MID_HOME0}/system/unix/inmidas /usr/bin/inmidas
	dosym ${MID_HOME0}/system/unix/gomidas /usr/bin/gomidas
	dosym ${MID_HOME0}/system/ftoc-new ${MID_HOME0}/system/good-ftoc
}
