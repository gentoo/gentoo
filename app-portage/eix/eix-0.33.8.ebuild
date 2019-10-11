# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools bash-completion-r1 flag-o-matic tmpfiles

DESCRIPTION="Search and query ebuilds"
HOMEPAGE="https://github.com/vaeth/eix/"
SRC_URI="https://github.com/vaeth/eix/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~riscv s390 ~sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug doc nls sqlite"

BOTHDEPEND="nls? ( virtual/libintl )
	sqlite? ( >=dev-db/sqlite-3:= )"
RDEPEND="${BOTHDEPEND}
	>=app-shells/push-2.0-r1
	>=app-shells/quoter-3.0_p2-r1"
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

	sed -e "/eixf_source=/s:push.sh:cat \"${EROOT}usr/share/push/push.sh\":" \
		-e "/eixf_source=/s:quoter_pipe.sh:cat \"${EROOT}usr/share/quoter/quoter_pipe.sh\":" \
		-i src/eix-functions.sh.in || die
	sed -e "s:'\$(bindir)/eix-functions.sh':cat \\\\\"${EROOT}usr/share/eix/eix-functions\\\\\":" \
		-i src/Makefile.am || die
	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_enable debug paranoic-asserts)
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

	# https://github.com/vaeth/eix/issues/35
	append-cxxflags -std=c++14

	# work around https://github.com/vaeth/eix/issues/64, bug#687988
	local -x mv_fCXXFLAGS_cache='-mindirect-branch=thunk'

	econf "${myconf[@]}"
}

src_install() {
	default
	dobashcomp bash/eix
	dotmpfiles tmpfiles.d/eix.conf

	rm -r "${ED%/}"/usr/bin/eix-functions.sh || die

}

pkg_postinst() {
		tmpfiles_process eix.conf

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
