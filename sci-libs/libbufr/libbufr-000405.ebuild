# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils fortran-2 toolchain-funcs

MY_P="${PN/lib/}dc_${PV}"

DESCRIPTION="ECMWF BUFR library - includes both C and Fortran example utilities"
HOMEPAGE="https://software.ecmwf.int/wiki/display/BUFR/BUFRDC+Home"
SRC_URI="https://software.ecmwf.int/wiki/download/attachments/35752466/${MY_P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
# needs someone to test on these: ~alpha ~hppa ~ia64 ~sparc etc ...

IUSE="debug doc examples lto"

RDEPEND="
	virtual/fortran
	"

DEPEND="sys-apps/findutils"

S=${WORKDIR}/${MY_P}

if use lto; then
	RESTRICT="strip"
fi

pkg_setup() {
	fortran-2_pkg_setup
	case "$(tc-getFC)" in
		*gfortran)
			export CNAME="_gfortran"
			;;
		*g77)
			export CNAME="_gnu"
			;;
		*pgf90|*pgf77)
			export CNAME=""
			;;
		ifc|ifort)
			export CNAME="_intel"
			;;
	esac

	elog "Note non-GNU compilers are not currently supported on non-x86"
	elog "architectures.  If you need it, please submit a patch..."

	export target="linux"
	export A64=""
	export R64=""
	case "${ARCH}" in
		amd64)
			export R64="R64"
			export A64="A64"
			;;
		ppc64)
			export target="ppc_G5"
			;;
		ppc)
			export target="ppc"
			;;
		*)
			;;
	esac
}

src_prepare() {
	update_configs
	epatch "${FILESDIR}"/${P}-makefile.patch

	local config="config/config.$target$CNAME$R64$A64"

	if [[ "${ARCH}" == "ppc" ]] ; then
		sed -i -e "s|= -mcpu=G4 -mtune=G4|= |" ${config}
	elif [[ "${ARCH}" == "ppc64" ]] ; then
		sed -i -e "s|= -mcpu=G5 -mtune=G5|= |" \
			-e "s|-fdefault-real-8|-fdefault-real-8 -fdefault-double-8|" \
			${config}
	elif [[ "${ARCH}" == "amd64" ]] ; then
		cp ${config}.in ${config}
		sed -i -e "s|-fdefault-real-8|-fdefault-real-8 -fdefault-double-8|" \
			${config}
	else
		cp ${config}.in ${config} || die "Error updating config!"
	fi

	sed -i -e "s:DEBUG = -O2:DEBUG = -g:g" ${config}
	use debug || sed -i -e "s:DEBUG = -g:DEBUG =:g" ${config}

	# add local CFLAGS to build flags
	sed -i -e "s|\$(DEBUG)|${CFLAGS} \$(DEBUG) -fPIC|" \
		-e 's|emos|/usr/share/bufrtables|g' ${config}

	# add local LDFLAGS to bins
	sed -i \
		-e "s|-o|${LDFLAGS} -fPIC -o|" \
		examples/Makefile \
		bufrtables/Makefile
}

src_compile() {
	export BUFR_TABLES="${S}"/bufrtables
	EBUILD_ARCH="${ARCH}"
	EBUILD_CFLAGS="${CFLAGS}"
	unset ARCH CFLAGS

	tc-export CC FC AR NM RANLIB
	export STRIP="/bin/true"
	TC_FLAGS="CC=$CC FC=$FC AR=$AR RANLIB=$RANLIB"
	ARFLAGS="rv"

	if use lto; then
		PLUGIN_PATH="--plugin=$(gcc -print-prog-name=liblto_plugin.so)"
		tc-ld-is-gold && ARFLAGS="rv ${PLUGIN_PATH}"
	fi

	# emake won't work with this fossil...
	BUFRFLAGS="ARCH=$target R64=$R64 CNAME=$CNAME"
	make $TC_FLAGS ARFLAGS="${ARFLAGS}" $BUFRFLAGS || die "make failed"

	generate_files

	ARCH="${EBUILD_ARCH}"
	CFLAGS="${EBUILD_CFLAGS}"
}

src_test() {
	unset ARCH CFLAGS
	BUFRFLAGS="ARCH=$target R64=$R64 CNAME=$CNAME"
	make $BUFRFLAGS test || die "make test failed"

	ARCH="${EBUILD_ARCH}"
	CFLAGS="${EBUILD_CFLAGS}"
}

src_install() {
	# install library
	dolib.a libbufr$R64.a

	dosbin bufrtables/{bufr2txt_tables,bufr_split_tables,txt2bufr_tables}
	dobin examples/{bufr_decode_all,create_bufr,decode_bufr,decode_bufr_image,tdexp}

	keepdir /usr/share/bufrtables
	insinto /usr/share/bufrtables
	doins -r bufrtables/{B,C,D}*.*

	# files generated above
	doenvd 20${PN}

	dodoc README
	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins doc/*.pdf
	fi

	if use examples ; then
		newdoc examples/README README.examples
		insinto /usr/share/doc/${PF}/examples
		doins examples/{*.F,*.c,Makefile}
	fi
}

pkg_postinst() {
	elog
	elog "This is the only GPL'd BUFR decoder library written in C/Fortran"
	elog "but the build system is an old kluge that pre-dates the discovery"
	elog "of fire.  File bugs as usual if you have build/runtime problems."
	elog ""
	elog "The default BUFR tables are stored in /usr/share/bufrtables, so"
	elog "add your local tables there if needed.  Only a static lib is"
	elog "installed currently, as shared lib support is incomplete (feel"
	elog "free to submit a patch :)"
	elog ""
	elog "The installed user-land bufr utilities are just the examples;"
	elog "the main library is really all there is (and there are no man"
	elog "pages either).  Install the examples and use the source, Luke..."
	elog
}

generate_files() {
	## Do not remove blank lines from the response file
	cat <<-EOF > 20${PN}
	BUFR_TABLES="/usr/share/bufrtables"
	EOF
}

update_configs() {
	find . -type f -name \*.distinct -o -name \*.f -o -name \*.in \
		 | xargs chmod -x
	cp options/options_linux options/options_ppc
	cp options/options_linux options/options_ppc_G5
	cp pbio/sources.linux pbio/sources.ppc
	cp pbio/sources.linux pbio/sources.ppc_G5
	pushd config > /dev/null
		cp config.ppc_gfortran.in config.ppc_gfortran
		cp config.ppc_gfortranR64.in config.ppc_gfortranR64
		cp config.ppc_gfortran_G5.in config.ppc_gfortran_G5
		cp config.ppc_gfortranR64_G5.in config.ppc_gfortranR64_G5
	popd > /dev/null
}
