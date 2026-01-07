# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
FORTRAN_NEEDED=fortran

inherit desktop flag-o-matic fortran-2 toolchain-funcs xdg

DESCRIPTION="Motif based XY-plotting tool"
HOMEPAGE="https://plasma-gate.weizmann.ac.il/Grace/"
SRC_URI="
	ftp://plasma-gate.weizmann.ac.il/pub/${PN}/src/stable/${P/_p*}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}-${PV/*_p}.debian.tar.xz
"

SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="fftw fortran jpeg netcdf png"

DEPEND="
	media-libs/t1lib
	media-libs/tiff:=
	virtual/zlib:=
	>=x11-libs/motif-2.3:0
	x11-libs/xbae
	fftw? ( sci-libs/fftw:3.0= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	netcdf? ( sci-libs/netcdf:= )
	png? ( media-libs/libpng:0= )"
RDEPEND="${DEPEND}
	x11-misc/xdg-utils"

S="${WORKDIR}/${P/_p*}"

PATCHES=(
	# Fix for missing defines when fortran is disabled
	"${FILESDIR}"/${PN}-5.1.21-fortran.patch
	# Fix a leak (from freebsd)
	"${FILESDIR}"/${PN}-5.1.22-dlmodule.patch
	# Honor -noask option and avoid accidentally overwritting files
	"${FILESDIR}"/${PN}-5.1.25-honor-noask.patch
	# Fix C99 compat (from Fedora); included in debian "source-hardening"???
	#"${FILESDIR}"/${PN}-c99.patch
	"${FILESDIR}"/${PN}-configure-c99.patch
)

pkg_setup() {
	fortran-2_pkg_setup
}

src_prepare() {
	default

	# Debian patches
	for p in $(<"${WORKDIR}"/debian/patches/series) ; do
		# We have a safer one
		[[ ${p} = configure-implicit-declarations.diff ]] && continue

		eapply -p1 "${WORKDIR}/debian/patches/${p}"
	done

	# don't strip if not asked for
	sed -i \
		-e 's:$(INSTALL_PROGRAM) -s:$(INSTALL_PROGRAM):g' \
		{auxiliary,grconvert,src}/Makefile || die

	sed -i \
		-e 's:$(GRACE_HOME)/bin:$(PREFIX)/bin:g' \
		-e "s:\$(GRACE_HOME)/lib:\$(PREFIX)/$(get_libdir):g" \
		-e 's:$(GRACE_HOME)/include:$(PREFIX)/include:g' \
		-e 's:$(PREFIX)/man:$(PREFIX)/share/man:g' \
		Makefile */Makefile || die "sed failed"

	sed -i \
		-e 's:bin/grconvert:grconvert:' \
		-e 's:auxiliary/fdf2fit:fdf2fit:' \
		gracerc || die
}

src_configure() {
	# -Werror=strict-aliasing, -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/863293
	append-flags -fno-strict-aliasing

	# https://bugs.gentoo.org/946273
	append-cflags -std=gnu17

	filter-lto

	tc-export CC AR

	# the configure script just produces a basic Make.conf
	# and a config.h
	econf \
		--disable-pdfdrv \
		--disable-xmhtml \
		--without-bundled-xbae \
		--without-bundled-t1lib \
		--enable-grace-home="${EPREFIX}"/usr/share/${PN} \
		--with-helpviewer="xdg-open %s" \
		--with-editor="xdg-open %s" \
		--with-printcmd="lpr" \
		--x-includes="${EPREFIX}"/usr/include \
		--x-libraries="${EPREFIX}"/usr/$(get_libdir) \
		$(use_with fftw) \
		$(use_enable fortran f77-wrapper) \
		$(use_enable netcdf) \
		$(use_enable jpeg jpegdrv) \
		$(use_enable png pngdrv) \
		$(use_with fortran f77 $(tc-getFC))
}

src_install() {
	default

	dosym ../../${PN}/examples /usr/share/doc/${PF}/examples
	dosym ../../${PN}/doc /usr/share/doc/${PF}/html

	doman "${ED}"/usr/share/doc/${PF}/html/*.1
	rm -f "${ED}"/usr/share/doc/${PF}/html/*.1 || die

	domenu "${FILESDIR}"/${PN}.desktop
	for size in 16 22 24 32; do
		newicon -s "${size}" "${WORKDIR}"/debian/icons/grace"${size}".png "${PN}.png"
	done
	doicon -s 48 "${WORKDIR}"/debian/icons/grace.png
	doicon -s scalable "${WORKDIR}"/debian/grace.svg
}
