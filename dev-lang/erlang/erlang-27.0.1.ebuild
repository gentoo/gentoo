# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
WX_GTK_VER="3.2-gtk3"

inherit autotools flag-o-matic java-pkg-opt-2 systemd toolchain-funcs wxwidgets

UPSTREAM_V="$(ver_cut 1-2)"

DESCRIPTION="Erlang programming language, runtime environment and libraries (OTP)"
HOMEPAGE="https://www.erlang.org/ https://github.com/erlang/otp"
SRC_URI="https://github.com/erlang/otp/archive/OTP-${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/${PN}/otp/releases/download/OTP-${UPSTREAM_V}/otp_doc_man_${UPSTREAM_V}.tar.gz
		-> ${PN}_doc_man_${UPSTREAM_V}.tar.gz
	doc? ( https://github.com/${PN}/otp/releases/download/OTP-${UPSTREAM_V}/otp_doc_html_${UPSTREAM_V}.tar.gz
		 -> ${PN}_doc_html_${UPSTREAM_V}.tar.gz )"
S="${WORKDIR}"/otp-OTP-${PV}

LICENSE="Apache-2.0"
# We use this subslot because Compiled HiPE Code can be loaded on the exact
# same build of ERTS that was used when compiling the code.  See
# http://erlang.org/doc/system_principles/misc.html for more information.
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc java +kpoll odbc sctp ssl systemd tk wxwidgets"

RDEPEND="
	acct-group/epmd
	acct-user/epmd
	sys-libs/ncurses:0
	sys-libs/zlib
	java? ( >=virtual/jdk-1.8:* )
	odbc? ( dev-db/unixODBC )
	sctp? ( net-misc/lksctp-tools )
	ssl? ( >=dev-libs/openssl-0.9.7d:0= )
	systemd? ( sys-apps/systemd )
	wxwidgets? (
		dev-libs/glib:2
		x11-libs/wxGTK:${WX_GTK_VER}[X,opengl]
		virtual/glu
	)
"
DEPEND="${RDEPEND}
	dev-lang/perl
"

PATCHES=(
	"${FILESDIR}"/${PN}-27.0-dont-ignore-LDFLAGS.patch
	"${FILESDIR}"/${PN}-24.0.2-serial-configure.patch
	"${FILESDIR}"/${PN}-25.1.2-c99.patch # Bug #882887
	"${FILESDIR}"/${PN}-26.2.4-test-errorinfo.patch
)

SITEFILE=50"${PN}"-gentoo.el

QA_CONFIG_IMPL_DECL_SKIP=(
	# FreeBSD & OpenBSD
	pthread_set_name_np
)

src_prepare() {
	default

	tc-export AR CPP CXX LD

	# bug #797886: erlang's VM does unsafe casts for ints
	# to pointers and back. This breaks on gcc-11 -flto.
	append-flags -fno-strict-aliasing

	# Ensure that we use erl_interface's libei.a, and not the system
	# libei.so from dev-libs/libei. Bug #912888.
	sed -i 's/-lei$/-l:libei.a/' \
		"${S}"/lib/odbc/c_src/Makefile.in || die
	(cd "${S}"/lib/odbc &&
		 eautoconf -B "${S}"/make/autoconf &&
		 eautoheader -B "${S}"/make/autoconf) || die
}

src_configure() {
	use wxwidgets && setup-wxwidgets

	local myconf=(
		--disable-builtin-zlib

		# don't search for static zlib
		--with-ssl-zlib=no

		$(use_enable kpoll kernel-poll)
		$(use_with java javac)
		$(use_with odbc)
		$(use_enable sctp)
		$(use_with ssl ssl)
		$(use_enable ssl dynamic-ssl-lib)
		$(use_enable systemd)
		$(usex wxwidgets "--with-wx-config=${WX_CONFIG}" "--with-wxdir=/dev/null")
	)
	econf "${myconf[@]}"
}

src_compile() {
	emake
	use doc && emake docs DOC_TARGETS=chunks
}

extract_version() {
	local path="$1"
	local var_name="$2"
	sed -n -e "/^${var_name} = \(.*\)$/s::\1:p" "${S}/${path}/vsn.mk" || die "extract_version() failed"
}

src_install() {
	local erl_libdir_rel="$(get_libdir)/erlang"
	local erl_libdir="/usr/${erl_libdir_rel}"
	local erl_interface_ver="$(extract_version lib/erl_interface EI_VSN)"
	local erl_erts_ver="$(extract_version erts VSN)"
	local my_manpath="/usr/share/${PN}/man"

	[[ -z "${erl_erts_ver}" ]] && die "Couldn't determine erts version"
	[[ -z "${erl_interface_ver}" ]] && die "Couldn't determine interface version"

	emake INSTALL_PREFIX="${D}" install

	if use doc ; then
		emake INSTALL_PREFIX="${D}" install-docs DOC_TARGETS=chunks

		# Note: we explicitly install docs into:
		#     /usr/share/doc/${PF}/{doc,lib,erts-*}
		# To maintain that layout we gather everything in 'html-docs'.
		# See bug #684376.
		mkdir html-docs || die
		mv "${WORKDIR}"/doc "${WORKDIR}"/lib "${WORKDIR}"/erts-* html-docs/ || die
		local DOCS=( "AUTHORS" "HOWTO"/* "README.md" "CONTRIBUTING.md" html-docs/. )
		docompress -x /usr/share/doc/${PF}
	else
		local DOCS=("README.md")
	fi

	einstalldocs

	dosym "../${erl_libdir_rel}/bin/erl" /usr/bin/erl
	dosym "../${erl_libdir_rel}/bin/erlc" /usr/bin/erlc
	dosym "../${erl_libdir_rel}/bin/escript" /usr/bin/escript
	dosym "../${erl_libdir_rel}/lib/erl_interface-${erl_interface_ver}/bin/erl_call" /usr/bin/erl_call
	dosym "../${erl_libdir_rel}/erts-${erl_erts_ver}/bin/beam.smp" /usr/bin/beam.smp

	## Clean up the no longer needed files
	rm "${ED}/${erl_libdir}/Install" || die

	# Bug #922743
	docompress "${my_manpath}"

	insinto "${my_manpath}"
	doins -r "${WORKDIR}"/man/*
	# extend MANPATH, so the normal man command can find it
	# see bug 189639
	newenvd - "90erlang" <<-_EOF_
		MANPATH="${my_manpath}"
	_EOF_

	newinitd "${FILESDIR}"/epmd.init-r3 epmd
	use systemd && systemd_newunit "${FILESDIR}"/epmd.service-r1 epmd.service
}

src_test() {
	# Only run a subset of tests to test that everything was built
	# successfully, otherwise we will be here for a long time.
	emake kernel_test ARGS="-suite os_SUITE"
}
