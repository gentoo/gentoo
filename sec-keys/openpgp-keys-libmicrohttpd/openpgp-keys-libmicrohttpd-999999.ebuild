# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used to sign GNU libmicrohttpd releases"
HOMEPAGE="https://savannah.gnu.org/projects/libmicrohttpd/"
if [[ ${PV} == 9999* ]] ; then
	PROPERTIES="live"

	BDEPEND="|| ( net-misc/wget[gnutls] net-misc/wget[ssl] )"
else
	KARLSON2K_ID='EA812DBEFA5A7EF17DA8F2C1460A317C3326D2AE'
	CHRISTIAN_ID='D8423BCB326C7907033929C7939E6BE1E29FC3CC'
	# Technically public keys are not stable.
	# While the fingerprint is stable, the contents of the key can be
	# changed at any time by an additional user ID (email address) or
	# an additional signature.
	#SRC_URI="https://grothoff.org/christian/grothoff.asc -> christiangrothoff-${CHRISTIAN_ID}.asc
	#	https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x${KARLSON2K_ID} -> karlson2k-${KARLSON2K_ID}.asc"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

S="${WORKDIR}"

LICENSE="public-domain"
SLOT="${PV}"

src_unpack() {
	if [[ ${PV} == 9999* ]] ; then
		# The release keyring can be changed at any moment and should always match the latest release
		wget 'https://savannah.gnu.org/project/release-gpgkeys.php?group=libmicrohttpd&download=1' -O libmicrohttpd-keyring.gpg || die
	else
		default
	fi
}

src_install() {
	local files

	if [[ ${PV} == 9999* ]] ; then
		files=( "${WORKDIR}/libmicrohttpd-keyring.gpg" )
	else
		# Do not use possibly unstable downloadable files
		#files=( "${DISTDIR}/karlson2k-${KARLSON2K_ID}.asc"
		#	"${DISTDIR}/christiangrothoff-${CHRISTIAN_ID}.asc" )
		# Use predefined stable pubic key files
		files=( "${FILESDIR}/karlson2k-${KARLSON2K_ID}.asc"
			"${FILESDIR}/christiangrothoff-${CHRISTIAN_ID}.asc" )
	fi

	insinto /usr/share/openpgp-keys
	newins - libmicrohttpd-${PV}.asc < <(cat "${files[@]}" || die)
}
