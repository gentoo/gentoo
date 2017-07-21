# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils multilib python-single-r1

DESCRIPTION="A robust, high-performance CORBA 2 ORB"
HOMEPAGE="http://omniorb.sourceforge.net/"
SRC_URI="mirror://sourceforge/omniorb/${P}.tar.gz"

LICENSE="LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86"
IUSE="doc ssl static-libs"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	ssl? ( >=dev-libs/openssl-0.9.6b:0= )"
DEPEND="${RDEPEND}"

src_prepare() {
	# respect ldflags, bug #284191
	epatch \
		"${FILESDIR}"/ldflags.patch \
		"${FILESDIR}"/${P}-openssl-1.patch \
		"${FILESDIR}"/${P}-format-security.patch

	sed \
		-e 's/^CXXDEBUGFLAGS.*/CXXDEBUGFLAGS = $(OPTCXXFLAGS)/' \
		-e 's/^CDEBUGFLAGS.*/CDEBUGFLAGS = $(OPTCFLAGS)/' \
		-i mk/beforeauto.mk.in mk/platforms/i586_linux_2.0*.mk || \
		die "sed failed"
}

src_configure() {
	mkdir build && cd build || die

	local MY_CONF="--prefix=/usr --with-omniORB-config=/etc/omniorb/omniORB.cfg \
		--with-omniNames-logdir=/var/log/omniORB --libdir=/usr/$(get_libdir)"

	use ssl && MY_CONF="${MY_CONF} --with-openssl=/usr"

	ECONF_SOURCE=".." econf ${MY_CONF} $(use_enable static-libs static)
}

src_compile() {
	cd build || die
	emake OPTCFLAGS="${CFLAGS}" OPTCXXFLAGS="${CXXFLAGS}"
}

src_install() {
	cd build || die
	default
	# this looks redundant
	rm "${ED}/usr/bin/omniidlrun.py" || die

	cd "${S}" || die

	if use doc; then
		dohtml doc/*.html
		dohtml -r doc/omniORB
		docinto print
		dodoc doc/*.pdf
	fi

	cat <<- EOF > "${T}/90omniORB"
		PATH="/usr/share/omniORB/bin/scripts"
		OMNIORB_CONFIG="/etc/omniorb/omniORB.cfg"
	EOF
	doenvd "${T}/90omniORB"
	doinitd "${FILESDIR}"/omniNames

	cp "sample.cfg" "${T}/omniORB.cfg" || die
	cat <<- EOF >> "${T}/omniORB.cfg"
		# resolve the omniNames running on localhost
		InitRef = NameService=corbaname::localhost
	EOF
	insinto /etc/omniorb
	doins "${T}"/omniORB.cfg

	keepdir /var/log/omniORB

	python_optimize
	python_fix_shebang "${ED}"/usr/bin/omniidl
}

pkg_postinst() {
	elog "Since 4.1.2, the omniORB init script has been renamed to omniNames for clarity."
}
