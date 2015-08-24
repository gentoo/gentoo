# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# The Debian ca-certificates package merely takes the CA database as it exists
# in the nss package and repackages it for use by openssl.
#
# The issue with using the compiled debs directly is two fold:
# - they do not update frequently enough for us to rely on them
# - they pull the CA database from nss tip of tree rather than the release
#
# So we take the Debian source tools and combine them with the latest nss
# release to produce (largely) the same end result.  The difference is that
# now we know our cert database is kept in sync with nss and, if need be,
# can be sync with nss tip of tree more frequently to respond to bugs.

# When triaging bugs from users, here's some handy tips:
# - To see what cert is hitting errors, use openssl:
#   openssl s_client -port 443 -CApath /etc/ssl/certs/ -host $HOSTNAME
#   Focus on the errors written to stderr.
#
# - Look at the upstream log as to why certs were added/removed:
#   https://hg.mozilla.org/projects/nss/log/tip/lib/ckfw/builtins/certdata.txt
#
# - If people want to add/remove certs, tell them to file w/mozilla:
#   https://bugzilla.mozilla.org/enter_bug.cgi?product=NSS&component=CA%20Certificates&version=trunk

EAPI="4"
PYTHON_COMPAT=( python2_7 )

inherit eutils python-any-r1

if [[ ${PV} == *.* ]] ; then
	# Compile from source ourselves.
	PRECOMPILED=false
	inherit versionator

	DEB_VER=$(get_version_component_range 1)
	NSS_VER=$(get_version_component_range 2-)
	RTM_NAME="NSS_${NSS_VER//./_}_RTM"
else
	# Debian precompiled version.
	PRECOMPILED=true
	inherit unpacker
fi

DESCRIPTION="Common CA Certificates PEM files"
HOMEPAGE="http://packages.debian.org/sid/ca-certificates"
NMU_PR=""
if ${PRECOMPILED} ; then
	SRC_URI="mirror://debian/pool/main/c/${PN}/${PN}_${PV}${NMU_PR:++nmu}${NMU_PR}_all.deb"
else
	SRC_URI="mirror://debian/pool/main/c/${PN}/${PN}_${DEB_VER}${NMU_PR:++nmu}${NMU_PR}.tar.xz
		ftp://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/${RTM_NAME}/src/nss-${NSS_VER}.tar.gz
		cacert? ( https://dev.gentoo.org/~anarchy/patches/nss-3.14.1-add_spi+cacerts_ca_certs.patch )"
fi

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE=""
${PRECOMPILED} || IUSE+=" +cacert"

DEPEND=""
if ${PRECOMPILED} ; then
	# platforms like AIX don't have a good ar
	DEPEND+="
		kernel_AIX? ( app-arch/deb2targz )
		!<sys-apps/portage-2.1.10.41"
fi
# openssl: we run `c_rehash`; newer version for alt-cert-paths #552540
# debianutils: we run `run-parts`
RDEPEND="${DEPEND}
	>=dev-libs/openssl-1.0.1o
	sys-apps/debianutils"

if ! ${PRECOMPILED}; then
	DEPEND+=" ${PYTHON_DEPS}"
fi

S=${WORKDIR}

pkg_setup() {
	# For the conversion to having it in CONFIG_PROTECT_MASK,
	# we need to tell users about it once manually first.
	[[ -f "${EPREFIX}"/etc/env.d/98ca-certificates ]] \
		|| ewarn "You should run update-ca-certificates manually after etc-update"
}

src_unpack() {
	${PRECOMPILED} || default

	mv ${PN}-*/ ${PN} || die

	# Do all the work in the image subdir to avoid conflicting with source
	# dirs in $WORKDIR.  Need to perform everything in the offset #381937
	mkdir -p "image/${EPREFIX}"
	cd "image/${EPREFIX}" || die

	${PRECOMPILED} && unpacker_src_unpack
}

src_prepare() {
	cd "image/${EPREFIX}" || die
	if ! ${PRECOMPILED} ; then
		mkdir -p usr/sbin
		cp -p "${S}"/${PN}/sbin/update-ca-certificates usr/sbin/ || die

		if use cacert ; then
			pushd "${S}"/nss-${NSS_VER} >/dev/null
			epatch "${DISTDIR}"/nss-3.14.1-add_spi+cacerts_ca_certs.patch
			popd >/dev/null
		fi
	fi

	epatch "${FILESDIR}"/${PN}-20141019-root.patch
	local relp=$(echo "${EPREFIX}" | sed -e 's:[^/]\+:..:g')
	sed -i \
		-e '/="$ROOT/s:ROOT/:ROOT'"${EPREFIX}"'/:' \
		-e '/RELPATH="\.\./s:"$:'"${relp}"'":' \
		usr/sbin/update-ca-certificates || die
}

src_compile() {
	cd "image/${EPREFIX}" || die
	if ! ${PRECOMPILED} ; then
		python_setup
		local d="${S}/${PN}/mozilla"
		# Grab the database from the nss sources.
		cp "${S}"/nss-${NSS_VER}/nss/lib/ckfw/builtins/{certdata.txt,nssckbi.h} "${d}" || die
		emake -C "${d}"

		# Now move the files to the same places that the precompiled would.
		mkdir -p etc/ssl/certs etc/ca-certificates/update.d usr/share/ca-certificates/mozilla
		if use cacert ; then
			mkdir -p usr/share/ca-certificates/{cacert.org,spi-inc.org}
			mv "${d}"/CAcert_Inc..crt usr/share/ca-certificates/cacert.org/cacert.org_root.crt || die
			mv "${d}"/SPI_Inc..crt usr/share/ca-certificates/spi-inc.org/spi-cacert-2008.crt || die
		fi
		mv "${d}"/*.crt usr/share/ca-certificates/mozilla/ || die
	else
		mv usr/share/doc/{ca-certificates,${PF}} || die
	fi

	(
	echo "# Automatically generated by ${CATEGORY}/${PF}"
	echo "# $(date -u)"
	echo "# Do not edit."
	cd usr/share/ca-certificates
	find * -name '*.crt' | LC_ALL=C sort
	) > etc/ca-certificates.conf

	sh usr/sbin/update-ca-certificates --root "${S}/image" || die
}

src_install() {
	cp -pPR image/* "${D}"/ || die
	if ! ${PRECOMPILED} ; then
		cd ca-certificates
		doman sbin/*.8
		dodoc debian/README.* examples/ca-certificates-local/README
	fi

	echo 'CONFIG_PROTECT_MASK="/etc/ca-certificates.conf"' > 98ca-certificates
	doenvd 98ca-certificates
}

pkg_postinst() {
	if [ -d "${EROOT}/usr/local/share/ca-certificates" ] ; then
		# if the user has local certs, we need to rebuild again
		# to include their stuff in the db.
		# However it's too overzealous when the user has custom certs in place.
		# --fresh is to clean up dangling symlinks
		"${EROOT}"/usr/sbin/update-ca-certificates --root "${ROOT}"
	fi

	local c badcerts=0
	for c in $(find -L "${EROOT}"etc/ssl/certs/ -type l) ; do
		ewarn "Broken symlink for a certificate at $c"
		badcerts=1
	done
	if [ $badcerts -eq 1 ]; then
		ewarn "Removing the following broken symlinks:"
		ewarn "$(find -L "${EROOT}"/etc/ssl/certs/ -type l -printf '%p -> %l\n' -delete)"
	fi
}
