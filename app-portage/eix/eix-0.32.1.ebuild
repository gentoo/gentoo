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
IUSE="debug +dep doc nls optimization +required-use security strong-optimization
	strong-security sqlite swap-remote tools"

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
		$(use_enable debug debugging)
		$(use_enable nls)
		$(use_enable optimization)
		$(use_enable security)
		$(use_enable strong-optimization)
		$(use_enable strong-security)
		$(use_enable swap-remote)
		$(use_enable tools separate-tools)
		$(use_with dep dep-default)
		$(use_with doc extra-doc)
		$(use_with prefix always-accept-keywords)
		$(use_with required-use required-use-default)
		$(use_with sqlite)
		--with-zsh-completion
		--with-portage-rootpath="${ROOTPATH}"
		--with-eprefix-default="${EPREFIX}"
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	dobashcomp bash/eix
	systemd_dotmpfilesd tmpfiles.d/eix.conf
}

pkg_postinst() {
	local cache=${EROOT%/}/var/cache/${PN}
	if [[ ! -d ${cache} ]]; then
		mkdir "${cache}" || die
		if ! use prefix; then
			chown portage:portage "${cache}" || die
		fi
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
