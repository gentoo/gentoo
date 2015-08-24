# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic autotools toolchain-funcs

DESCRIPTION="The GNU Scientific Library"
HOMEPAGE="https://www.gnu.org/software/gsl/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="cblas-external static-libs"

RDEPEND="cblas-external? ( virtual/cblas )"
DEPEND="${RDEPEND}
	app-eselect/eselect-cblas
	virtual/pkgconfig"

DOCS=( AUTHORS BUGS ChangeLog NEWS README THANKS TODO )

pkg_pretend() {
	# prevent to use external cblas from a previously installed gsl
	local current_lib
	if use cblas-external; then
		current_lib=$(eselect cblas show | cut -d' ' -f2)
		if [[ ${current_lib} == gsl ]]; then
			ewarn "USE flag cblas-external is set: linking gsl with an external cblas."
			ewarn "However the current selected external cblas is gsl."
			ewarn "Please install and/or eselect another cblas"
			die "Circular gsl dependency"
		fi
	fi
}

src_prepare() {
	ESELECT_PROF="gsl"

	# bug 349005
	[[ $(tc-getCC)$ == *gcc* ]] && \
		[[ $(tc-getCC)$ != *apple* ]] && \
		[[ $(gcc-major-version)$(gcc-minor-version) -eq 44 ]] \
		&& filter-mfpmath sse
	filter-flags -ffast-math

	epatch "${FILESDIR}"/${P}-cblas.patch
	eautoreconf

	cp "${FILESDIR}"/eselect.cblas.gsl "${T}"/
	sed -i -e "s:/usr:${EPREFIX}/usr:" "${T}"/eselect.cblas.gsl || die
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i -e 's/\.so\([\.0-9]\+\)\?/\1.dylib/g' \
			"${T}"/eselect.cblas.gsl || die
	fi
}

src_configure() {
	if use cblas-external; then
		export CBLAS_LIBS="$($(tc-getPKG_CONFIG) --libs cblas)"
		export CBLAS_CFLAGS="$($(tc-getPKG_CONFIG) --cflags cblas)"
	fi
	econf \
		--enable-shared \
		$(use_with cblas-external) \
		$(use_enable static-libs static)
}

src_install() {
	default

	find "${ED}" -name '*.la' -exec rm -f {} +

	# take care of pkgconfig file for cblas implementation.
	sed -e "s/@LIBDIR@/$(get_libdir)/" \
		-e "s/@PV@/${PV}/" \
		-e "/^prefix=/s:=:=${EPREFIX}:" \
		-e "/^libdir=/s:=:=${EPREFIX}:" \
		"${FILESDIR}"/cblas.pc.in > cblas.pc \
		|| die "sed cblas.pc failed"
	insinto /usr/$(get_libdir)/blas/gsl
	doins cblas.pc || die "installing cblas.pc failed"
	eselect cblas add $(get_libdir) "${T}"/eselect.cblas.gsl \
		${ESELECT_PROF}
}

pkg_postinst() {
	local p=cblas
	local current_lib=$(eselect ${p} show | cut -d' ' -f2)
	if [[ ${current_lib} == ${ESELECT_PROF} || -z ${current_lib} ]]; then
		# work around eselect bug #189942
		local configfile="${EROOT}"/etc/env.d/${p}/$(get_libdir)/config
		[[ -e ${configfile} ]] && rm -f ${configfile}
		eselect ${p} set ${ESELECT_PROF}
		elog "${p} has been eselected to ${ESELECT_PROF}"
	else
		elog "Current eselected ${p} is ${current_lib}"
		elog "To use ${p} ${ESELECT_PROF} implementation, you have to issue (as root):"
		elog "\t eselect ${p} set ${ESELECT_PROF}"
	fi
}

src_test() {
	emake -j1 check || die
}
