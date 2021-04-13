# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

COMMIT="c80e46678e1025f3116bdcc75563364744adbe18"
DESCRIPTION="Lib that implements the client side of the SMTP protocol"
HOMEPAGE="https://libesmtp.github.io/"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/libesmtp/libESMTP.git"
else
	#SRC_URI="https://github.com/libesmtp/libESMTP/archive/v${PV/_}.tar.gz -> ${P}.tar.gz"
	SRC_URI="https://github.com/libesmtp/libESMTP/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/libESMTP-${COMMIT}"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="LGPL-2.1 GPL-2"
SLOT="0/7"
IUSE="ssl static-libs threads"

RDEPEND="ssl? ( >=dev-libs/openssl-1.1.0:0= )"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS docs/{bugreport,ChangeLog,faq}.md NEWS Notes README.md TODO )

src_configure() {
	local emesonargs=(
		-Ddefault_library="$(usex static-libs both shared)"
		$(meson_feature ssl tls)
		$(meson_feature threads pthreads)
	)
	meson_src_configure
}
