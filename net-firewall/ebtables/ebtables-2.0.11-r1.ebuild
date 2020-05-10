# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs autotools

MY_PV="$(ver_rs 3 '-' )"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Controls Ethernet frame filtering on a Linux bridge, MAC NAT and brouting"
HOMEPAGE="http://ebtables.sourceforge.net/"
SRC_URI="ftp://ftp.netfilter.org/pub/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="+perl static"

BDEPEND=">=app-eselect/eselect-iptables-20200508"
# The ebtables-save script is written in perl.
RDEPEND="${BDEPEND}
	perl? ( dev-lang/perl )
	net-misc/ethertypes"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.11-makefile.patch"

	# Enhance ebtables-save to take table names as parameters bug #189315
	"${FILESDIR}/${PN}-2.0.11-ebt-save.patch"

	# from upstream git
	"${FILESDIR}/ebtables-2.0.11-remove-stray-atsign.patch"
)

pkg_setup() {
	if use static; then
		ewarn "You've chosen static build which is useful for embedded devices."
		ewarn "It has no init script. Make sure that's really what you want."
	fi
}

src_prepare() {
	default

	# don't install perl scripts if USE=perl is disabled
	if ! use perl; then
		sed -e '/sbin_SCRIPTS/ d' -i Makefile.am || die
	fi

	eautoreconf
}

src_configure() {
	econf \
		--bindir="/bin" \
		--sbindir="/sbin" \
		--libdir=/$(get_libdir)/${PN} \
		--sysconfdir="/usr/share/doc/${PF}" \
		$(use_enable static)
}

src_compile() {
	emake $(usex static 'static ebtables-legacy.8' '')
}

src_install() {
	local -a DOCS=( ChangeLog THANKS )

	if ! use static; then
		emake DESTDIR="${D}" install
		keepdir /var/lib/ebtables/
		newinitd "${FILESDIR}"/ebtables.initd-r1 ebtables
		newconfd "${FILESDIR}"/ebtables.confd-r1 ebtables

		find "${D}" -name '*.la' -type f -delete || die
	else
		into /
		newsbin static ebtables
		insinto /etc
		doins ethertypes
	fi

	newman ebtables-legacy.8 ebtables.8
	einstalldocs
}

pkg_postinst() {
	if ! eselect ebtables show &>/dev/null; then
		elog "Current ebtables implementation is unset, setting to ebtables-legacy"
		eselect ebtables set ebtables-legacy
	fi

	eselect ebtables show
}

pkg_prerm() {
	if [[ -z ${REPLACED_BY_VERSION} ]] && has_version 'net-firewall/iptables[nftables]'; then
		elog "Resetting ebtables symlinks to xtables-nft-multi before removal"
		eselect ebtables set xtables-nft-multi
	else
		elog "Unsetting ebtables symlinks before removal"
		eselect ebtables unset
	fi
}
