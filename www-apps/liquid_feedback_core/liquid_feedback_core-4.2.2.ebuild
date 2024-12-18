# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P=${PN}-v${PV}

DESCRIPTION="Internet platforms for proposition development and decision making"
HOMEPAGE="https://www.public-software-group.org/liquid_feedback"
SRC_URI="https://www.public-software-group.org/pub/projects/liquid_feedback/backend/v${PV}/${MY_P}.tar.gz
	https://dev.gentoo.org/~tupone/distfiles/${MY_P}.tar.gz"

S=${WORKDIR}/${MY_P}

LICENSE="HPND CC-BY-2.5"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-db/postgresql:="
RDEPEND="${DEPEND}
	acct-user/apache
	dev-db/pgLatLon"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.4-gentoo.patch
	"${FILESDIR}"/${PN}-4.0.0-gentoo.patch
)

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		CPPFLAGS="-I $(pg_config --includedir)" \
		LDFLAGS="${LDFLAGS} -L $(pg_config --libdir)"
}

src_install() {
	dobin lf_update lf_update_issue_order lf_update_suggestion_order lf_export
	dobin "${FILESDIR}"/lf_update.sh
	insinto /usr/share/${PN}
	doins -r {core,init,demo,test,geoindex_install}.sql update
	dodoc README "${FILESDIR}"/postinstall-en-4.txt
	keepdir /var/log/liquid_feedback
	fowners apache:apache /var/log/liquid_feedback
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}
