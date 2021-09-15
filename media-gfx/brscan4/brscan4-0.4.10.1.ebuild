# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eapi8-dosym readme.gentoo-r1 rpm

MY_P="${PN}-${PV%.*}-${PV##*.}"
DESCRIPTION="Brother scanner driver"
HOMEPAGE="https://www.brother.com/"
SRC_URI="
	amd64? ( https://download.brother.com/welcome/dlf105203/${MY_P}.x86_64.rpm )
	x86? ( https://download.brother.com/welcome/dlf105202/${MY_P}.i386.rpm )"
S="${WORKDIR}/opt/brother/scanner/${PN}"

LICENSE="Brother"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="zeroconf"
RESTRICT="strip"

RDEPEND="media-gfx/sane-backends
	virtual/libusb:0
	zeroconf? ( net-dns/avahi )"

QA_PREBUILT="opt/brother/*"

src_install() {
	local dest=/opt/brother/scanner/${PN}
	local lib=$(get_libdir)

	insinto /etc${dest}
	doins Brsane4.ini brsanenetdevice4.cfg
	doins -r models4
	dosym8 -r {/etc,}${dest}/Brsane4.ini
	dosym8 -r {/etc,}${dest}/brsanenetdevice4.cfg
	dosym8 -r {/etc,}${dest}/models4

	exeinto ${dest}
	doexe brsaneconfig4
	dosym8 -r {${dest},/usr/bin}/brsaneconfig4

	if use zeroconf; then
		doexe brscan_cnetconfig
		# Don't install brscan_gnetconfig because it depends on gtk+:2
	fi

	into ${dest}
	dolib.so "${WORKDIR}"/usr/${lib}/sane/libsane-brother4.so.1.0.7
	dosym libsane-brother4.so.1.0.7 ${dest}/${lib}/libsane-brother4.so.1
	dosym libsane-brother4.so.1.0.7 ${dest}/${lib}/libsane-brother4.so
	dosym8 -r {${dest}/${lib},/usr/${lib}/sane}/libsane-brother4.so.1.0.7
	dosym libsane-brother4.so.1.0.7 /usr/${lib}/sane/libsane-brother4.so.1
	dosym libsane-brother4.so.1.0.7 /usr/${lib}/sane/libsane-brother4.so

	insinto /etc/sane.d/dll.d
	newins - ${PN} <<< "brother4"

	local DOC_CONTENTS="If want to use a remote scanner over the network,
		you will have to add it with \"brsaneconfig4\"."
	use zeroconf || DOC_CONTENTS+="\\n\\nNote that querying the network
		(\"brsaneconfig4 -q\") will not work unless you emerge ${PN} with
		the zeroconf flag enabled."

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
