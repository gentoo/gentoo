# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rpm

DESCRIPTION="Serves ProtonMail to IMAP/SMTP clients"
HOMEPAGE="https://protonmail.com/bridge/"
SRC_URI="https://protonmail.com/download/${P/-bin/}-1.x86_64.rpm"

RESTRICT="bindist mirror"

LICENSE="MIT protonmail-bridge-EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="
	app-crypt/libsecret
	dev-libs/glib:2
	media-sound/pulseaudio
	virtual/opengl
"

S="${WORKDIR}"

QA_PREBUILT="*"

src_install() {
	# Using doins -r would strip executable bits from all binaries
	cp -pPR "${S}"/usr "${D}"/ || die "Failed to copy files"

	dosym "Desktop-Bridge" "/usr/bin/${PN}" || die

	cat <<-EOF > "${T}/50-${PN}" || die
		SEARCH_DIRS_MASK="/usr/lib*/protonmail/bridge"
	EOF
	insinto /etc/revdep-rebuild
	doins "${T}/50-${PN}"
}
