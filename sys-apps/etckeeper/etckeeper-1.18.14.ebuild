# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 prefix systemd tmpfiles

DESCRIPTION="A collection of tools to let /etc be stored in a repository"
HOMEPAGE="https://etckeeper.branchable.com/"
SRC_URI="https://git.joeyh.name/index.cgi/etckeeper.git/snapshot/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 ~arm ppc64 ~x86"
SLOT="0"
IUSE="cron test"

BDEPEND="test? (
	dev-util/bats
	dev-vcs/git
)"

RDEPEND="app-portage/portage-utils
	cron? ( virtual/cron )
	|| (
		dev-vcs/git
		dev-vcs/mercurial
		dev-vcs/darcs
	)
"

RESTRICT="!test? ( test )"

PATCHES=( "${FILESDIR}"/${PN}-1.18.14-gentoo.patch )

src_prepare() {
	default
	hprefixify *.d/* etckeeper
	sed -i \
		-e s'@zsh/vendor-completions@zsh/site-functions@' \
		-e s"@/lib/systemd/system@"$(systemd_get_systemunitdir)"@" \
		Makefile || die
	rm -v init.d/60darcs-deleted-symlinks || die
}

src_compile() {
	:
}

src_install() {
	emake DESTDIR="${ED}" install

	doenvd "$(prefixify_ro "${FILESDIR}"/99${PN})"

	newbashcomp bash_completion ${PN}
	dodoc doc/README.mdwn
	newdoc "${FILESDIR}"/bashrc-r1 bashrc.example

	rm -rv "${ED}/var/cache" || die
	newtmpfiles "${FILESDIR}/${PN}".tmpfilesd "${PN}".conf

	if use cron ; then
		exeinto /etc/cron.daily
		newexe debian/cron.daily etckeeper
	fi
}

pkg_postinst() {
	tmpfiles_process "${PN}.conf"

	elog "${PN} supports git, mercurial and darcs"
	elog "This ebuild just ensures at least one is installed!"
	elog
	elog "You may want to adjust your /etc/portage/bashrc"
	elog "see the example file in /usr/share/doc/${PF}"
	elog
	elog "To initialise your etc-dir as a repository run:"
	elog "${PN} init -d /etc"
}
