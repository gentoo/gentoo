# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PLOCALES="de ru"
inherit bash-completion-r1 l10n systemd

DESCRIPTION="Search and query ebuilds"
HOMEPAGE="https://github.com/vaeth/eix/"
SRC_URI="https://github.com/vaeth/eix/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~ia64-hpux ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug doc nls sqlite"

BOTHDEPEND="nls? ( virtual/libintl )
	sqlite? ( >=dev-db/sqlite-3:= )"
RDEPEND="${BOTHDEPEND}
	app-shells/push
	app-shells/quoter"
DEPEND="${BOTHDEPEND}
	app-arch/xz-utils
	nls? ( sys-devel/gettext )"

pkg_setup() {
	# remove stale cache file to prevent collisions
	local old_cache=${EROOT%/}/var/cache/${PN}
	if [[ -f ${old_cache} ]]; then
		rm "${old_cache}" || die
	fi
}

src_prepare() {
	default
	sed -i -e "s:/:${EPREFIX}/:" tmpfiles.d/eix.conf || die
}

src_configure() {
	local myconf=(
		$(use_enable debug paranoicasserts)
		$(use_enable nls)
		$(use_with doc extra-doc)
		$(use_with sqlite)

		# default configuration
		$(use_with prefix always-accept-keywords)
		--with-dep-default
		--with-required-use-default

		# paths
		--with-portage-rootpath="${ROOTPATH}"
		--with-eprefix-default="${EPREFIX}"

		# build a single executable with symlinks
		--disable-separate-binaries
		--disable-separate-tools

		# used purely to control/disrespect *FLAGS
		--disable-debugging
		--disable-new_dialect
		--disable-optimization
		--disable-strong-optimization
		--disable-security
		--disable-nopie-security
		--disable-strong-security
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	dobashcomp bash/eix
	systemd_dotmpfilesd tmpfiles.d/eix.conf

	keepdir /var/cache/eix
}

pkg_postinst() {
	if ! use prefix; then
		# note: if this is done in src_install(), portage:portage
		# ownership may be reset to root
		fowners portage:portage "${EROOT%/}"/var/cache/eix
	fi

	local obs=${EROOT%/}/var/cache/eix.previous
	if [[ -f ${obs} ]]; then
		ewarn "Found obsolete ${obs}, please remove it"
	fi
}

pkg_postrm() {
	if [[ ! -n ${REPLACED_BY_VERSION} ]]; then
		rm -rf "${EROOT%/}/var/cache/${PN}" || die
	fi
}
