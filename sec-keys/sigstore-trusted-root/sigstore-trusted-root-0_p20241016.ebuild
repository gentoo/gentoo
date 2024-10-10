# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="trusted-root.json for dev-python/sigstore"
HOMEPAGE="https://www.sigstore.dev/"
SRC_URI="
	https://dev.gentoo.org/~mgorny/dist/${P}.tar.xz
	test? (
		https://www.python.org/ftp/python/3.13.0/Python-3.13.0.tar.xz.sigstore
	)
"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
PROPERTIES="test_network"
RESTRICT="test"

BDEPEND="
	test? (
		dev-python/sigstore
		sys-apps/diffutils
	)
"

src_test() {
	local common_args=(
		--bundle "${DISTDIR}"/Python-3.13.0.tar.xz.sigstore
		--cert-identity thomas@python.org
		--cert-oidc-issuer https://accounts.google.com
		sha256:086de5882e3cb310d4dca48457522e2e48018ecd43da9cdf827f6a0759efb07d
	)

	cp -r "${WORKDIR}"/{.cache,.local} "${HOME}"/ || die
	einfo "Attempting offline verification ..."
	sigstore verify identity --offline "${common_args[@]}" ||
		die "Verification failed with extracted trust root"
	einfo "Attempting online verification ..."
	sigstore verify identity "${common_args[@]}" ||
		die "Verification failed in online mode"

	# check if anything needs updating
	if ! diff -ur "${WORKDIR}" "${HOME}"; then
		local tar="${WORKDIR}/${PN}-0_p$(date +%Y%m%d).tar"
		cd "${HOME}" || die
		tar -c -v -f "${tar}" $(find .cache .local -type f | sort) || die
		xz -v9e "${tar}" || die
		die "Changes found, please update to use ${tar}.xz"
	fi
}

src_install() {
	insinto /usr/share/sigstore-gentoo
	doins -r .cache .local
}
