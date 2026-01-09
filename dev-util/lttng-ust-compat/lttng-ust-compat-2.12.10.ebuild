# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools verify-sig

MY_PN="${PN/-compat/}"
MY_PV="${PV/_rc/-rc}"
MY_P="${MY_PN}-${MY_PV}"
MY_SLOT="$(ver_cut 1-2)"

DESCRIPTION="Linux Trace Toolkit - UST library"
HOMEPAGE="
	https://lttng.org
	https://github.com/lttng/lttng-ust/
"
SRC_URI="
	https://lttng.org/files/${MY_PN}/${MY_P}.tar.bz2
	verify-sig? ( https://lttng.org/files/${MY_PN}/${MY_P}.tar.bz2.asc )
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0/${MY_SLOT}"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="numa"

DEPEND="
	dev-libs/userspace-rcu:=
	numa? ( sys-process/numactl )
"
RDEPEND="
	!dev-util/lttng-ust:${SLOT}
	${DEPEND}
"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-mathieudesnoyers )"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/mathieudesnoyers.asc

src_prepare() {
	default

	sed -i -e '/SUBDIRS/s:examples::' doc/Makefile.am || die

	eautoreconf
}

src_configure() {
	econf $(use_enable numa) --disable-maintainer-mode
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	# Don't conflict with >=dev-util/lttng-ust-2.13
	rm "${ED}"/usr/bin/lttng-gen-tp || die
	rm -r "${ED}"/usr/include/ || die
	rm "${ED}"/usr/$(get_libdir)/liblttng-ust-ctl.so
	rm "${ED}"/usr/$(get_libdir)/liblttng-ust-cyg-profile-fast.so
	rm "${ED}"/usr/$(get_libdir)/liblttng-ust-cyg-profile.so
	rm "${ED}"/usr/$(get_libdir)/liblttng-ust-dl.so
	rm "${ED}"/usr/$(get_libdir)/liblttng-ust-fd.so
	rm "${ED}"/usr/$(get_libdir)/liblttng-ust-fork.so
	rm "${ED}"/usr/$(get_libdir)/liblttng-ust-libc-wrapper.so
	rm "${ED}"/usr/$(get_libdir)/liblttng-ust-pthread-wrapper.so
	rm "${ED}"/usr/$(get_libdir)/liblttng-ust.so
	rm "${ED}"/usr/$(get_libdir)/liblttng-ust-tracepoint.so
	rm -r "${ED}"/usr/$(get_libdir)/pkgconfig/ || die
	rm -r "${ED}"/usr/share/man/ || die
}
