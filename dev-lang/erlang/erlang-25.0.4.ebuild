# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
WX_GTK_VER="3.0-gtk3"

inherit elisp-common flag-o-matic java-pkg-opt-2 systemd toolchain-funcs wxwidgets

# NOTE: If you need symlinks for binaries please tell maintainers or
# open up a bug to let it be created.

UPSTREAM_V="$(ver_cut 1-2)"

DESCRIPTION="Erlang programming language, runtime environment and libraries (OTP)"
HOMEPAGE="https://www.erlang.org/"
SRC_URI="https://github.com/erlang/otp/archive/OTP-${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/erlang/otp/releases/download/OTP-${UPSTREAM_V}/otp_doc_man_${UPSTREAM_V}.tar.gz -> ${PN}_doc_man_${UPSTREAM_V}.tar.gz
	doc? ( https://github.com/erlang/otp/releases/download/OTP-${UPSTREAM_V}/otp_doc_html_${UPSTREAM_V}.tar.gz -> ${PN}_doc_html_${UPSTREAM_V}.tar.gz )"

LICENSE="Apache-2.0"
# We use this subslot because Compiled HiPE Code can be loaded on the exact
# same build of ERTS that was used when compiling the code.  See
# http://erlang.org/doc/system_principles/misc.html for more information.
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc emacs java +kpoll odbc sctp ssl systemd tk wxwidgets"

RDEPEND="
	acct-group/epmd
	acct-user/epmd
	sys-libs/ncurses:0
	sys-libs/zlib
	emacs? ( >=app-editors/emacs-23.1:* )
	java? ( >=virtual/jdk-1.8:* )
	odbc? ( dev-db/unixODBC )
	sctp? ( net-misc/lksctp-tools )
	ssl? ( >=dev-libs/openssl-0.9.7d:0= )
	systemd? ( sys-apps/systemd )
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}[X,opengl] )
"
DEPEND="${RDEPEND}
	dev-lang/perl
"

S="${WORKDIR}/otp-OTP-${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-22.0-dont-ignore-LDFLAGS.patch
	"${FILESDIR}"/${PN}-24.0.2-serial-configure.patch
)

SITEFILE=50"${PN}"-gentoo.el

src_prepare() {
	default

	tc-export AR CPP CXX LD

	# bug #797886: erlang's VM does unsafe casts for ints
	# to pointers and back. This breaks on gcc-11 -flto.
	append-flags -fno-strict-aliasing
}

src_configure() {
	use wxwidgets && setup-wxwidgets

	local myconf=(
		--disable-builtin-zlib

		# don't search for static zlib
		--with-ssl-zlib=no

		$(use_enable kpoll kernel-poll)
		$(use_with java javac)
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

	if use emacs ; then
		pushd lib/tools/emacs &>/dev/null || die
		elisp-compile *.el
		popd &>/dev/null || die
	fi
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

	insinto "${my_manpath}"
	doins -r "${WORKDIR}"/man/*
	# extend MANPATH, so the normal man command can find it
	# see bug 189639
	newenvd - "90erlang" <<-_EOF_
		MANPATH="${my_manpath}"
	_EOF_

	if use emacs ; then
		elisp-install erlang lib/tools/emacs/*.{el,elc}
		sed -e "s:/usr/share:${EPREFIX}/usr/share:g" \
			"${FILESDIR}/${SITEFILE}" > "${T}/${SITEFILE}" || die
		elisp-site-file-install "${T}/${SITEFILE}"
	fi

	newinitd "${FILESDIR}"/epmd.init-r2 epmd
	newconfd "${FILESDIR}"/epmd.confd-r2 epmd
	use systemd && systemd_newunit "${FILESDIR}"/epmd.service-r1 epmd.service
}

src_test() {
	# Only run a subset of tests to test that everything was built
	# successfully, otherwise we will be here for a long time.
	emake kernel_test ARGS="-suite os_SUITE"
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
