# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libbufr/libbufr-000360.ebuild,v 1.9 2012/10/18 20:41:24 jlec Exp $

EAPI=2

inherit eutils fortran-2 flag-o-matic toolchain-funcs

MY_P="${PN/lib/}_${PV}"

DESCRIPTION="ECMWF BUFR library - includes both C and Fortran example utilities"
HOMEPAGE="http://www.ecmwf.int/products/data/software/bufr.html"
SRC_URI="http://www.ecmwf.int/products/data/software/download/software_files/${MY_P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# needs someone to test on these: ~alpha ~hppa ~ia64 ~ppc ~ppc64 ~sparc etc ...

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

	export target="linux"
	case "${ARCH}" in
		amd64)
			export A64="A64"
			export R64="R64"
			;;
		*)
			export A64=""
			export R64=""
			;;
	esac
}

src_prepare() {
	find . -type f | xargs chmod -x
	chmod +x bufrtables/links.sh

	local config="config/config.$target$CNAME$R64$A64"

	sed -i -e "s:DEBUG = -O2:DEBUG = -g:g" $config || die

	# add local CFLAGS to and build flags
	use debug || sed -i -e "s|\$(DEBUG)|${CFLAGS}|" $config

	# add local LDFLAGS to link commands
	sed -i \
		-e "s|-o|${LDFLAGS} -o|" \
		examples/Makefile \
		bufrtables/Makefile || die
	# updated for newer gcc
	epatch "${FILESDIR}"/${P}-gcc-includes.patch
}

src_compile() {
	EBUILD_ARCH="${ARCH}"
	EBUILD_CFLAGS="${CFLAGS}"
	unset ARCH CFLAGS
	tc-export
	append-flags -DTABLE_PATH="/usr/share/bufrtables"

	make ARCH=linux || die "make failed"

	ARCH="${EBUILD_ARCH}"
	CFLAGS="${EBUILD_CFLAGS}"

	generate_files

	cd "${S}"/examples
	make ARCH=linux decode_bufr bufr_decode create_bufr \
		decode_bufr_image tdexp || die "make examples failed"
}

src_test() {
	cd "${S}"/examples
	BUFR_TABLES="${S}/bufrtables/" ./decode_bufr -i \
		../data/ISMD01_OKPR.bufr < ../response_file
}

src_install() {
	dolib.a libbufrR64.a
	dosbin bufrtables/{bufr2txt_tables,bufr_split_tables,txt2bufr_tables}
	dobin examples/{create_bufr,decode_bufr,decode_bufr_image}

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
	echo
	elog "This is the only GPL'd BUFR decoder library written in C/Fortran"
	elog "but the build system is an old kluge that pre-dates the discovery"
	elog "of fire. File bugs as usual if you have build/runtime problems."
	echo
	elog "The default BUFR tables are stored in /usr/share/bufrtables, so"
	elog "add your local tables there if needed.  Only a static lib is"
	elog "installed currently, as shared lib support is incomplete (feel"
	elog "free to submit a patch :)"
	echo
	elog "The installed user-land bufr utilities are just the examples;"
	elog "the main library is really all there is (and there are no man"
	elog "pages either).  Install the examples and use the source, Luke..."
	echo
}

generate_files() {
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
