# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit eutils fortran-2 flag-o-matic toolchain-funcs

MY_P="${PN/lib/}_${PV}"

DESCRIPTION="ECMWF BUFR library - includes both C and Fortran example utilities"
HOMEPAGE="http://www.ecmwf.int/products/data/software/bufr.html"
SRC_URI="http://www.ecmwf.int/products/data/software/download/software_files/${MY_P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug doc examples"

RDEPEND=""
DEPEND="sys-apps/findutils"

S=${WORKDIR}/${MY_P}

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
	elog "architectures. If you need it, please subit a patch..."

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
	epatch "${FILESDIR}"/${PN}-makefile.patch

	local config="config/config.$target$CNAME$R64$A64"

	if [[ "${ARCH}" == "ppc" ]] ; then
		sed -i -e "s|= -mcpu=G4 -mtune=G4|= |" $config
	elif [[ "${ARCH}" == "ppc64" ]] ; then
		sed -i -e "s|= -mcpu=G5 -mtune=G5|= |" $config
	fi

	sed -i -e "s:DEBUG = -O2:DEBUG = -g:g" $config

	# add local CFLAGS to and build flags
	use debug || sed -i -e "s|\$(DEBUG)|${CFLAGS}|" $config

	# add local LDFLAGS to link commands
	sed -i \
		-e "s|-o|${LDFLAGS} -o|" \
		examples/Makefile \
		bufrtables/Makefile
}

src_compile() {
	EBUILD_ARCH="${ARCH}"
	EBUILD_CFLAGS="${CFLAGS}"
	unset ARCH CFLAGS
	tc-export CC
	append-flags -DTABLE_PATH="/usr/share/bufrtables"

	# emake won't work with this fossil...
	make ARCH=$target || die "make failed"

	pushd examples > /dev/null
	make ARCH=$target decode_bufr bufr_decode \
		create_bufr decode_bufr_image tdexp \
		|| die "make examples failed"
	popd > /dev/null

	generate_files

	ARCH="${EBUILD_ARCH}"
	CFLAGS="${EBUILD_CFLAGS}"
}

src_test() {
	cd "${S}"/examples
	BUFR_TABLES="${S}/bufrtables/" ./decode_bufr -i \
		../data/ISMD01_OKPR.bufr < ../response_file
}

src_install() {
	# install library
	dolib.a libbufr$R64.a

	dosbin bufrtables/{bufr2txt_tables,bufr_split_tables,txt2bufr_tables}
	dobin examples/{create_bufr,decode_bufr,decode_bufr_image,tdexp}

	keepdir /usr/share/bufrtables
	insinto /usr/share/bufrtables
	doins bufrtables/*000*

	# files generated above
	doenvd 20${PN}

	dodoc README
	if use doc ; then
		insinto /usr/share/doc/${P}
		doins doc/*.pdf
	fi

	if use examples ; then
		newdoc examples/README README.examples
		insinto /usr/share/doc/${P}/examples
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
	CONFIG_PROTECT="/usr/share/bufrtables"
	EOF

	cat <<-EOF > response_file
	N
	N
	N
	1

	N
	EOF
}

update_configs() {
	find . -type f | xargs chmod -x
	chmod +x bufrtables/links.sh
	cp options/options_linux options/options_ppc
	cp options/options_linux options/options_ppc_G5
	cp pbio/sources.linux pbio/sources.ppc
	cp pbio/sources.linux pbio/sources.ppc_G5
	pushd config > /dev/null
		cp config.ppc config.ppc_gfortran
		cp config.ppcR64 config.ppc_gfortranR64
		cp config.ppc_G5 config.ppc_G5_gfortran
		cp config.ppcR64_G5 config.ppc_G5_gfortranR64
	popd > /dev/null
}
