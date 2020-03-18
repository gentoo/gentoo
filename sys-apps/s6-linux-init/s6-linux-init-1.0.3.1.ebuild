# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Generates an init binary for s6-based init systems"
HOMEPAGE="https://www.skarnet.org/software/s6-linux-init/"
SRC_URI="https://www.skarnet.org/software/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~x86"
IUSE="static static-libs +sysv-utils"

REQUIRED_USE="static? ( static-libs )"

RDEPEND=">=dev-lang/execline-2.5.3.0:=[static-libs?]
	>=dev-libs/skalibs-2.9.1.0:=[static-libs?]
	>=sys-apps/s6-2.9.0.1:=[static-libs?]
	sysv-utils? (
		!sys-apps/systemd[sysv-utils]
		!sys-apps/sysvinit
	)
"
DEPEND="${RDEPEND}"

HTML_DOCS=( doc/. )

src_prepare() {
	default

	# Avoid QA warning for LDFLAGS addition; avoid overriding -fstack-protector
	sed -i -e 's/.*-Wl,--hash-style=both$/:/' -e '/-fno-stack-protector$/d' \
		configure || die
}

src_configure() {
	econf \
		--bindir=/bin \
		--dynlibdir=/usr/$(get_libdir) \
		--skeldir=/etc/s6-linux-init/skel \
		--libdir=/usr/$(get_libdir)/${PN} \
		--with-dynlib=/usr/$(get_libdir) \
		--with-lib=/usr/$(get_libdir)/s6 \
		--with-lib=/usr/$(get_libdir)/skalibs \
		--with-sysdeps=/usr/$(get_libdir)/skalibs \
		--enable-shared \
		$(use_enable static allstatic) \
		$(use_enable static static-libc) \
		$(use_enable static-libs static)
}

src_install() {
	default

	if use sysv-utils ; then
		"${D}/bin/s6-linux-init-maker" -f "${D}/etc/s6-linux-init/skel" "${T}/dir" || die
		into /
		dosbin "${T}/dir/bin"/{halt,poweroff,reboot,shutdown,telinit}
	fi
}

pkg_postinst() {
	einfo "Read ${EROOT}/usr/share/doc/${PF}/html/quickstart.html"
	einfo "for usage instructions."
}
