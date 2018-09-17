# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WX_GTK_VER="3.0"

inherit autotools elisp-common java-pkg-opt-2 systemd versionator wxwidgets

# NOTE: If you need symlinks for binaries please tell maintainers or
# open up a bug to let it be created.

UPSTREAM_V="$(get_version_component_range 1-2)"

DESCRIPTION="Erlang programming language, runtime environment and libraries (OTP)"
HOMEPAGE="https://www.erlang.org/"
SRC_URI="https://github.com/erlang/otp/archive/OTP-${PV}.tar.gz -> ${P}.tar.gz
	http://erlang.org/download/otp_doc_man_${UPSTREAM_V}.tar.gz -> ${PN}_doc_man_${UPSTREAM_V}.tar.gz
	doc? ( http://erlang.org/download/otp_doc_html_${UPSTREAM_V}.tar.gz -> ${PN}_doc_html_${UPSTREAM_V}.tar.gz )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"

IUSE="dirty-schedulers doc emacs hipe java kpoll libressl odbc smp sctp ssl systemd tk"
REQUIRED_USE="dirty-schedulers? ( smp )" #621610

RDEPEND="
	ssl? (
		!libressl? ( >=dev-libs/openssl-0.9.7d:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	emacs? ( virtual/emacs )
	java? ( >=virtual/jdk-1.2:* )
	odbc? ( dev-db/unixODBC )
	systemd? ( sys-apps/systemd )
"
DEPEND="${RDEPEND}
	dev-lang/perl
	sctp? ( net-misc/lksctp-tools )
	sys-libs/zlib
	tk? ( dev-lang/tk )
	x11-libs/wxGTK:${WX_GTK_VER}[X,opengl]
	virtual/glu
"

S="${WORKDIR}/otp-OTP-${PV}"

PATCHES=(
		"${FILESDIR}/18.2.1-wx3.0.patch"
		"${FILESDIR}/${PN}-20.3.2-dont-ignore-LDFLAGS.patch"
		"${FILESDIR}/${PN}-add-epmd-pid-file-creation-for-openrc.patch"
	)

SITEFILE=50"${PN}"-gentoo.el

# Taken from the upstream build script, build_otp
erlang_create_lib_configure_in() {
	local bootstrap_apps="erts lib/asn1 lib/compiler lib/hipelib/ic lib/kernel
			 lib/parsetools lib/sasl lib/snmp lib/stdlib lib/syntax_tools"
	local sdirs=
	for lib_app in ${bootstrap_apps}; do
		case "${lib_app}" in
			lib/*)
				if [[ -f "${lib_app}/configure.in" ]]; then
					mv "${lib_app}/configure.in" "${lib_app}/configure.ac" || die
					app=`echo "${lib_app}" | sed "s|lib/\(.*\)|\1|"`
					sdirs="${sdirs}test ! -f ${app}/configure || AC_CONFIG_SUBDIRS(${app}/.)\n" || die
				fi;;
			*)
			;;
		esac
	done

	local sed_bootstrap="s%@BOOTSTRAP_CONFIGURE_APPS@%$sdirs%g"

	sdirs=
	for lib_app in lib/*; do
		local is_bapp=false
		for bapp in ${bootstrap_apps}; do
			test "${bapp} != ${lib_app}" || { "${is_bapp}"=true; break; }
		done
		if [[ "${is_bapp}" = false ]] && [[ -f "${lib_app}/configure.in" ]]; then
			mv "${lib_app}/configure.in" "${lib_app}/configure.ac" || die
			app=`echo "${lib_app}" | sed "s|lib/\(.*\)|\1|"` || die
			sdirs="${sdirs}    test ! -f ${app}/configure || AC_CONFIG_SUBDIRS(${app}/.)\n"
		fi
	done

	local sed_non_bootstrap="s%@NON_BOOTSTRAP_CONFIGURE_APPS@%$sdirs%g"

	rm -f lib/configure.in || die
	sed "$sed_bootstrap;$sed_non_bootstrap" > lib/configure.ac < lib/configure.in.src || die "Failed to create lib/configure.ac"

}

# Taken from the upstream build script, build_otp
erlang_distribute_config_helpers() {
	local aclocal_dirs=". ./lib/erl_interface ./lib/odbc ./lib/wx ./lib/megaco"
	local autoconf_aux_dirs="./lib/common_test/priv/auxdir ./lib/erl_interface/src/auxdir ./lib/common_test/test_server ./lib/wx/autoconf"

	local aclocal_master="./erts/aclocal.m4"
	local install_sh_master="./erts/autoconf/install-sh"
	local config_guess_master="./erts/autoconf/config.guess"
	local config_sub_master="./erts/autoconf/config.sub"

	for dir in ${aclocal_dirs}; do
		"${install_sh_master}" -m 644 -t "${dir}" "${aclocal_master}" || die
	done

	for dir in ${autoconf_aux_dirs}; do
		"${install_sh_master}" -d "${dir}" || die
		"${install_sh_master}" -t "${dir}" "${install_sh_master}" || die
		"${install_sh_master}" -t "${dir}" "${config_guess_master}" || die
		"${install_sh_master}" -t "${dir}" "${config_sub_master}" || die
	done
}

src_prepare() {
	default

	# Determines which directories to recurse into with autoconf
	erlang_create_lib_configure_in

	# Move local autoconf files into the neccessary directories
	erlang_distribute_config_helpers

	java-pkg-opt-2_src_prepare

	eautoreconf
}

src_configure() {
	need-wxwidgets unicode

	econf \
		--disable-builtin-zlib \
		$(use_enable dirty-schedulers) \
		$(use_enable hipe) \
		$(use_enable kpoll kernel-poll) \
		$(use_with java javac) \
		$(use_with odbc) \
		$(use_enable sctp) \
		$(use_enable smp smp-support) \
		$(use_with ssl) \
		$(use_with ssl ssl-rpath "no") \
		$(use_enable ssl dynamic-ssl-lib) \
		$(use_enable systemd) \
		--enable-threads
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
	sed -n -e "/^$2 = \(.*\)$/s::\1:p" "${S}/$1/vsn.mk"
}

src_install() {
	local ERL_LIBDIR="/usr/$(get_libdir)/erlang"
	local ERL_INTERFACE_VER="$(extract_version lib/erl_interface EI_VSN)"
	local ERL_ERTS_VER="$(extract_version erts VSN)"
	local MY_MANPATH="/usr/share/${PN}/man"

	[[ -z "${ERL_ERTS_VER}" ]] && die "Couldn't determine erts version"
	[[ -z "${ERL_INTERFACE_VER}" ]] && die "Couldn't determine interface version"

	emake INSTALL_PREFIX="${ED}" install

	if use doc ; then
		local DOCS=( "AUTHORS" "HOWTO"/* "README.md" "CONTRIBUTING.md" "${WORKDIR}"/doc/. "${WORKDIR}"/lib/. "${WORKDIR}"/erts-* )
		docompress -x /usr/share/doc/${PF}
	fi

	einstalldocs

	dosym "${ERL_LIBDIR}/bin/erl" /usr/bin/erl
	dosym "${ERL_LIBDIR}/bin/erlc" /usr/bin/erlc
	dosym "${ERL_LIBDIR}/bin/escript" /usr/bin/escript
	dosym \
		"${ERL_LIBDIR}/lib/erl_interface-${ERL_INTERFACE_VER}/bin/erl_call" \
		/usr/bin/erl_call

	if use smp; then
		dosym "${ERL_LIBDIR}/erts-${ERL_ERTS_VER}/bin/beam.smp" /usr/bin/beam.smp
	else
		dosym "${ERL_LIBDIR}/erts-${ERL_ERTS_VER}/bin/beam" /usr/bin/beam
	fi

	## Clean up the no longer needed files
	rm "${ED}/${ERL_LIBDIR}/Install" || die

	insinto "${MY_MANPATH}"

	doins -r "${WORKDIR}"/man/*

	# extend MANPATH, so the normal man command can find it
	# see bug 189639
	echo "MANPATH=\"${MY_MANPATH}\"" > "${T}/90erlang" || die
	doenvd "${T}/90erlang"

	if use emacs ; then
		pushd "${S}" &>/dev/null || die
		elisp-install erlang lib/tools/emacs/*.{el,elc}
		sed -e "s:/usr/share:${EPREFIX}/usr/share:g" \
			"${FILESDIR}/${SITEFILE}" > "${T}/${SITEFILE}" || die
		elisp-site-file-install "${T}/${SITEFILE}"
		popd &>/dev/null || die
	fi

	newinitd "${FILESDIR}"/epmd.init epmd
	systemd_dounit "${FILESDIR}"/epmd.service
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
