# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
#
# @ECLASS: bitcoincore.eclass
# @MAINTAINER:
# Luke Dashjr <luke_gentoo_bitcoin@dashjr.org>
# @BLURB: common code for Bitcoin Core ebuilds
# @DESCRIPTION:
# This eclass is used in Bitcoin Core ebuilds (bitcoin-qt, bitcoind,
# libbitcoinconsensus) to provide a single common place for the common ebuild
# stuff.
#
# The eclass provides all common dependencies as well as common use flags.

has "${EAPI:-0}" 5 || die "EAPI=${EAPI} not supported"

if [[ ! ${_BITCOINCORE_ECLASS} ]]; then

in_bcc_iuse() {
	local liuse=( ${BITCOINCORE_IUSE} )
	has "${1}" "${liuse[@]#[+-]}"
}

in_bcc_policy() {
	local liuse=( ${BITCOINCORE_POLICY_PATCHES} )
	has "${1}" "${liuse[@]#[+-]}"
}

DB_VER="4.8"
inherit autotools db-use eutils

if [ -z "$BITCOINCORE_COMMITHASH" ]; then
	inherit git-2
fi

fi

EXPORT_FUNCTIONS src_prepare src_test src_install

if in_bcc_iuse ljr || in_bcc_iuse 1stclassmsg || in_bcc_iuse zeromq || [ -n "$BITCOINCORE_POLICY_PATCHES" ]; then
	EXPORT_FUNCTIONS pkg_pretend
fi

if [[ ! ${_BITCOINCORE_ECLASS} ]]; then

# @ECLASS-VARIABLE: BITCOINCORE_COMMITHASH
# @DESCRIPTION:
# Set this variable before the inherit line, to the upstream commit hash.

# @ECLASS-VARIABLE: BITCOINCORE_IUSE
# @DESCRIPTION:
# Set this variable before the inherit line, to the USE flags supported.

# @ECLASS-VARIABLE: BITCOINCORE_LJR_DATE
# @DESCRIPTION:
# Set this variable before the inherit line, to the datestamp of the ljr
# patchset.

# @ECLASS-VARIABLE: BITCOINCORE_POLICY_PATCHES
# @DESCRIPTION:
# Set this variable before the inherit line, to a space-delimited list of
# supported policies.

MyPV="${PV/_/}"
MyPN="bitcoin"
MyP="${MyPN}-${MyPV}"

# These are expected to change in future versions
DOCS="${DOCS} doc/README.md doc/release-notes.md"
OPENSSL_DEPEND="dev-libs/openssl:0[-bindist]"
WALLET_DEPEND="sys-libs/db:$(db_ver_to_slot "${DB_VER}")[cxx]"
LIBEVENT_DEPEND=""
UNIVALUE_DEPEND=""
BITCOINCORE_LJR_NAME=ljr
[ -n "${BITCOINCORE_LJR_PV}" ] || BITCOINCORE_LJR_PV="${PV}"

case "${PV}" in
0.10*)
	BITCOINCORE_MINOR=10
	LIBSECP256K1_DEPEND="=dev-libs/libsecp256k1-0.0.0_pre20141212"
	case "${PVR}" in
	0.10.2)
		BITCOINCORE_RBF_DIFF="16f45600c8c372a738ffef544292864256382601...a23678edc70204599299459a206709a00e039db7"
		BITCOINCORE_RBF_PATCHFILE="${MyPN}-rbf-v0.10.2.patch"
		;;
	*)
		BITCOINCORE_RBF_DIFF="16f45600c8c372a738ffef544292864256382601...4890416cde655559eba09d3fd6f79db7d0d6314a"
		BITCOINCORE_RBF_PATCHFILE="${MyPN}-rbf-v0.10.2-r1.patch"
		;;
	esac
	BITCOINCORE_XT_DIFF="047a89831760ff124740fe9f58411d57ee087078...d4084b62c42c38bfe302d712b98909ab26ecce2f"
	;;
0.11*)
	BITCOINCORE_MINOR=11
	LIBSECP256K1_DEPEND="=dev-libs/libsecp256k1-0.0.0_pre20150423"
	# RBF is bundled with ljr patchset since 0.11.1
	if [ "${PVR}" = "0.11.0" ]; then
		BITCOINCORE_RBF_DIFF="5f032c75eefb0fe8ff79ed9595da1112c05f5c4a...660b96d24916b8ef4e0677e5d6162e24e2db447e"
		BITCOINCORE_RBF_PATCHFILE="${MyPN}-rbf-v0.11.0rc3.patch"
	fi
	;;
0.12*)
	BITCOINCORE_MINOR=12
	IUSE="${IUSE} libressl"
	OPENSSL_DEPEND="!libressl? ( dev-libs/openssl:0[-bindist] ) libressl? ( dev-libs/libressl )"
	if in_bcc_iuse libevent; then
		LIBEVENT_DEPEND="libevent? ( dev-libs/libevent )"
	else
		LIBEVENT_DEPEND="dev-libs/libevent"
	fi
	LIBSECP256K1_DEPEND="=dev-libs/libsecp256k1-0.0.0_pre20151118[recovery]"
	UNIVALUE_DEPEND="dev-libs/univalue"
	BITCOINCORE_LJR_NAME=knots
	if in_bcc_policy spamfilter; then
		REQUIRED_USE="${REQUIRED_USE} bitcoin_policy_spamfilter? ( ljr )"
	fi
	;;
9999*)
	BITCOINCORE_MINOR=9999
	BITCOINCORE_SERIES="9999"
	LIBEVENT_DEPEND="dev-libs/libevent"
	LIBSECP256K1_DEPEND=">dev-libs/libsecp256k1-0.0.0_pre20150422"
	UNIVALUE_DEPEND="dev-libs/univalue"
	;;
*)
	die "Unrecognised version"
	;;
esac

[ -n "${BITCOINCORE_SERIES}" ] || BITCOINCORE_SERIES="0.${BITCOINCORE_MINOR}.x"

LJR_PV() {
	local testsfx=
	if [ -n "${BITCOINCORE_LJR_PREV}" ]; then
		if [ "$1" = "dir" ]; then
			testsfx="/test/${BITCOINCORE_LJR_PREV}"
		else
			testsfx=".${BITCOINCORE_LJR_PREV}"
		fi
	fi
	echo "${BITCOINCORE_LJR_PV}.${BITCOINCORE_LJR_NAME}${BITCOINCORE_LJR_DATE}${testsfx}"
}
LJR_PATCHDIR="${MyPN}-$(LJR_PV ljr).patches"
LJR_PATCH() { echo "${WORKDIR}/${LJR_PATCHDIR}/${MyPN}-$(LJR_PV ljr).$@.patch"; }
LJR_PATCH_DESC="http://luke.dashjr.org/programs/${MyPN}/files/${MyPN}d/luke-jr/${BITCOINCORE_SERIES}/$(LJR_PV ljr)/${MyPN}-$(LJR_PV ljr).desc.txt"
if [ "$BITCOINCORE_MINOR" -ge 12 ]; then
	LJR_PATCH_DESC="http://bitcoinknots.org/files/${BITCOINCORE_SERIES}/$(LJR_PV dir)/${MyPN}-$(LJR_PV).desc.html"
fi

HOMEPAGE="http://bitcoincore.org/"

if [ -z "$BITCOINCORE_COMMITHASH" ]; then
	EGIT_PROJECT='bitcoin'
	EGIT_REPO_URI="git://github.com/bitcoin/bitcoin.git https://github.com/bitcoin/bitcoin.git"
else
	SRC_URI="https://github.com/${MyPN}/${MyPN}/archive/${BITCOINCORE_COMMITHASH}.tar.gz -> ${MyPN}-v${PV}${BITCOINCORE_SRC_SUFFIX}.tgz"
	if [ -z "${BITCOINCORE_NO_SYSLIBS}" ]; then
		SRC_URI="${SRC_URI} http://bitcoinknots.org/files/${BITCOINCORE_SERIES}/$(LJR_PV dir)/${LJR_PATCHDIR}.txz -> ${LJR_PATCHDIR}.tar.xz"
	fi
	if in_bcc_iuse addrindex; then
		SRC_URI="${SRC_URI} addrindex? ( https://github.com/btcdrak/bitcoin/compare/${BITCOINCORE_ADDRINDEX_DIFF}.diff -> ${BITCOINCORE_ADDRINDEX_PATCHFILE} )"
	fi
	if in_bcc_iuse xt; then
		BITCOINXT_PATCHFILE="${MyPN}xt-v${PV}.patch"
		SRC_URI="${SRC_URI} xt? ( https://github.com/bitcoinxt/bitcoinxt/compare/${BITCOINCORE_XT_DIFF}.diff -> ${BITCOINXT_PATCHFILE} )"
	fi
	if in_bcc_policy rbf && [ -n "${BITCOINCORE_RBF_DIFF}" ]; then
		SRC_URI="${SRC_URI} bitcoin_policy_rbf? ( https://github.com/petertodd/bitcoin/compare/${BITCOINCORE_RBF_DIFF}.diff -> ${BITCOINCORE_RBF_PATCHFILE} )"
	fi
	S="${WORKDIR}/${MyPN}-${BITCOINCORE_COMMITHASH}"
fi

bitcoincore_policy_iuse() {
	local mypolicy iuse_def new_BITCOINCORE_IUSE=
	for mypolicy in ${BITCOINCORE_POLICY_PATCHES}; do
		if [[ "${mypolicy:0:1}" =~ ^[+-] ]]; then
			iuse_def=${mypolicy:0:1}
			mypolicy="${mypolicy:1}"
		else
			iuse_def=
		fi
		new_BITCOINCORE_IUSE="$new_BITCOINCORE_IUSE ${iuse_def}bitcoin_policy_${mypolicy}"
	done
	echo $new_BITCOINCORE_IUSE
}
IUSE="$IUSE $BITCOINCORE_IUSE $(bitcoincore_policy_iuse)"
if in_bcc_policy rbf && in_bcc_iuse xt; then
	REQUIRED_USE="${REQUIRED_USE} bitcoin_policy_rbf? ( !xt )"
fi

BITCOINCORE_COMMON_DEPEND="
	${OPENSSL_DEPEND}
"
if ! has libevent ${BITCOINCORE_NO_DEPEND}; then
	BITCOINCORE_COMMON_DEPEND="${BITCOINCORE_COMMON_DEPEND} ${LIBEVENT_DEPEND}"
fi
if [ "${BITCOINCORE_NEED_LIBSECP256K1}" = "1" ]; then
	BITCOINCORE_COMMON_DEPEND="${BITCOINCORE_COMMON_DEPEND} $LIBSECP256K1_DEPEND"
fi
if [ "${PN}" = "libbitcoinconsensus" ]; then
	BITCOINCORE_COMMON_DEPEND="${BITCOINCORE_COMMON_DEPEND}
		test? (
			${UNIVALUE_DEPEND}
			>=dev-libs/boost-1.52.0[threads(+)]
		)
	"
else
	BITCOINCORE_COMMON_DEPEND="${BITCOINCORE_COMMON_DEPEND}
		${UNIVALUE_DEPEND}
		>=dev-libs/boost-1.52.0[threads(+)]
	"
fi
bitcoincore_common_depend_use() {
	in_bcc_iuse "$1" || return
	BITCOINCORE_COMMON_DEPEND="${BITCOINCORE_COMMON_DEPEND} $1? ( $2 )"
}
bitcoincore_common_depend_use upnp net-libs/miniupnpc
bitcoincore_common_depend_use wallet "${WALLET_DEPEND}"
bitcoincore_common_depend_use zeromq net-libs/zeromq
RDEPEND="${RDEPEND} ${BITCOINCORE_COMMON_DEPEND}"
DEPEND="${DEPEND} ${BITCOINCORE_COMMON_DEPEND}
	>=app-shells/bash-4.1
	sys-apps/sed
"
if [ "${BITCOINCORE_NEED_LEVELDB}" = "1" ]; then
	RDEPEND="${RDEPEND} virtual/bitcoin-leveldb"
fi
if in_bcc_iuse ljr; then
	if [ "$BITCOINCORE_SERIES" = "0.10.x" ]; then
		DEPEND="${DEPEND} ljr? ( dev-vcs/git )"
	elif [ "${BITCOINCORE_LJR_NAME}" = "knots" ]; then
		DEPEND="${DEPEND} ljr? ( dev-lang/perl )"
	fi
fi

bitcoincore_policymsg() {
	local USEFlag="bitcoin_policy_$1"
	in_iuse "${USEFlag}" || return
	if use "${USEFlag}"; then
		[ -n "$2" ] && einfo "$2"
	else
		[ -n "$3" ] && einfo "$3"
	fi
	bitcoincore_policymsg_flag=true
}

bitcoincore_pkg_pretend() {
	bitcoincore_policymsg_flag=false
	if use_if_iuse ljr || use_if_iuse 1stclassmsg || use_if_iuse addrindex || use_if_iuse xt || { use_if_iuse zeromq && [ "${BITCOINCORE_MINOR}" -lt 12 ]; }; then
		einfo "Extra functionality improvements to Bitcoin Core are enabled."
		bitcoincore_policymsg_flag=true
		if use_if_iuse addrindex addrindex; then
			einfo "Please be aware that the addrindex functionality is known to be unreliable."
		fi
	fi
	bitcoincore_policymsg cltv \
		"CLTV policy is enabled: Your node will recognise and assist OP_CHECKLOCKTIMEVERIFY (BIP65) transactions." \
		"CLTV policy is disabled: Your node will not recognise OP_CHECKLOCKTIMEVERIFY (BIP65) transactions."
	bitcoincore_policymsg cpfp \
		"CPFP policy is enabled: If you mine, you will give consideration to child transaction fees to pay for their parents." \
		"CPFP policy is disabled: If you mine, you will ignore transactions unless they have sufficient fee themselves, even if child transactions offer a fee to cover their cost."
	bitcoincore_policymsg dcmp \
		"Data Carrier Multi-Push policy is enabled: Your node will assist transactions with at most a single multiple-'push' data carrier output." \
		"Data Carrier Multi-Push policy is disabled: Your node will assist transactions with at most a single data carrier output with only a single 'push'."
	bitcoincore_policymsg rbf \
		"Replace By Fee policy is enabled: Your node will preferentially mine and relay transactions paying the highest fee, regardless of receive order." \
		"Replace By Fee policy is disabled: Your node will only accept the first transaction seen consuming a conflicting input, regardless of fee offered by later ones."
	bitcoincore_policymsg spamfilter \
		"Enhanced spam filter policy is enabled: Your node will identify notorious spam scripts and avoid assisting them. This may impact your ability to use some services (see link for a list)." \
		"Enhanced spam filter policy is disabled: Your node will not be checking for notorious spam scripts, and may assist them."
	$bitcoincore_policymsg_flag && einfo "For more information on any of the above, see ${LJR_PATCH_DESC}"
}

bitcoincore_git_apply() {
	local patchfile="$1"
	einfo "Applying ${patchfile##*/} ..."
	git apply --whitespace=nowarn "${patchfile}" || die
}

bitcoincore_predelete_patch() {
	local patchfile="$1"
	mkdir -p "${WORKDIR}/pdp"
	local tmpfile="${WORKDIR}/pdp/${patchfile##*/}"
	perl -ne '
		newline:
		if (m[(^diff .* b/(.*)$)]) {
			$a = "$1\n";
			$f = $2;
			$_ = <>;
			if (m[^deleted file]) {
				unlink($f) || die;
				while (!m[^diff ]) {
					$_ = <>
				}
				goto newline
			} else {
				print($a)
			}
		}
		print
	' <"${patchfile}" >"${tmpfile}" || die
	epatch "${tmpfile}"
}

bitcoincore_prepare() {
	local mypolicy
	if [ -n "${BITCOINCORE_NO_SYSLIBS}" ]; then
		true
	elif [ "${PV}" = "9999" ]; then
		epatch "${FILESDIR}/${PV}-syslibs.patch"
	else
		epatch "$(LJR_PATCH syslibs)"
	fi
	if use_if_iuse ljr; then
		if [ "${BITCOINCORE_LJR_NAME}" = "knots" ]; then
			epatch "$(LJR_PATCH f)"
			bitcoincore_predelete_patch "$(LJR_PATCH branding)"
			epatch "$(LJR_PATCH ts)"
		elif [ "${BITCOINCORE_SERIES}" = "0.10.x" ]; then
			# Regular epatch won't work with binary files
			bitcoincore_git_apply "$(LJR_PATCH ljrF)"
		else
			epatch "$(LJR_PATCH ljrF)"
		fi
	fi
	if use_if_iuse 1stclassmsg; then
		epatch "$(LJR_PATCH 1stclassmsg)"
	fi
	if use_if_iuse addrindex; then
		epatch "${DISTDIR}/${BITCOINCORE_ADDRINDEX_PATCHFILE}"
	fi
	if use_if_iuse xt; then
		epatch "${DISTDIR}/${BITCOINXT_PATCHFILE}"
	fi
	{ use_if_iuse zeromq && [ "${BITCOINCORE_MINOR}" -lt 12 ]; } && epatch "$(LJR_PATCH zeromq)"
	for mypolicy in ${BITCOINCORE_POLICY_PATCHES}; do
		mypolicy="${mypolicy#[-+]}"

		if [ "${BITCOINCORE_MINOR}" -ge 12 ]; then
			case "${mypolicy}" in
			rbf)
				use bitcoin_policy_rbf || sed -i 's/\(DEFAULT_ENABLE_REPLACEMENT = \)true/\1false/' src/main.h
				;;
			spamfilter)
				use bitcoin_policy_spamfilter || sed -i 's/\(DEFAULT_SPAMFILTER = \)true/\1false/' src/main.h
				;;
			*)
				die "Unknown policy ${mypolicy}"
			esac
			continue
		fi

		use bitcoin_policy_${mypolicy} || continue
		case "${mypolicy}" in
		rbf)
			if [ -n "${BITCOINCORE_RBF_PATCHFILE}" ]; then
				epatch "${DISTDIR}/${BITCOINCORE_RBF_PATCHFILE}"
			else
				epatch "$(LJR_PATCH ${mypolicy})"
			fi
			;;
		*)
			epatch "$(LJR_PATCH ${mypolicy})"
			;;
		esac
	done
}

bitcoincore_autoreconf() {
	eautoreconf
	rm -r src/leveldb || die
	rm -r src/secp256k1 || die
}

bitcoincore_src_prepare() {
	 bitcoincore_prepare
	 bitcoincore_autoreconf
}

bitcoincore_conf() {
	local my_econf=
	if use_if_iuse upnp; then
		my_econf="${my_econf} --with-miniupnpc --enable-upnp-default"
	else
		my_econf="${my_econf} --without-miniupnpc --disable-upnp-default"
	fi
	if use_if_iuse test; then
		my_econf="${my_econf} --enable-tests"
	else
		my_econf="${my_econf} --disable-tests"
	fi
	if use_if_iuse wallet; then
		my_econf="${my_econf} --enable-wallet"
	else
		my_econf="${my_econf} --disable-wallet"
	fi
	if ! use_if_iuse zeromq; then
		# NOTE: Older (pre-0.12) patches would disable ZMQ if --enable-zmq was passed
		my_econf="${my_econf} --disable-zmq"
	fi
	if [ -z "${BITCOINCORE_NO_SYSLIBS}" ]; then
		my_econf="${my_econf} --disable-util-cli --disable-util-tx"
	else
		my_econf="${my_econf} --without-utils"
	fi
	# Knots 0.12.0 errors if --with-libevent used for bitcoin{d,-cli}, so only disable it when not wanted
	if has libevent ${BITCOINCORE_NO_DEPEND} || { in_bcc_iuse libevent && ! use libevent; }; then
		my_econf="${my_econf} --without-libevent"
	fi
	if [ "${BITCOINCORE_NEED_LEVELDB}" = "1" ]; then
		# Passing --with-system-leveldb fails if leveldb is not installed, so only use it for targets that use LevelDB
		my_econf="${my_econf} --with-system-leveldb"
	fi
	econf \
		--disable-bench  \
		--disable-ccache \
		--disable-static \
		--with-system-libsecp256k1  \
		--with-system-univalue  \
		--without-libs    \
		--without-daemon  \
		--without-gui     \
		${my_econf}  \
		"$@"
}

bitcoincore_src_test() {
	emake check
}

bitcoincore_src_install() {
	default
	[ "${PN}" = "libbitcoinconsensus" ] || rm "${D}/usr/bin/test_bitcoin"
}

_BITCOINCORE_ECLASS=1
fi
