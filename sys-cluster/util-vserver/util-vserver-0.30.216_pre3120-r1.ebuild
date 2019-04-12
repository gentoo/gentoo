# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils bash-completion-r1

MY_P="${P/_/-}"

DESCRIPTION="Linux-VServer admin utilities"
HOMEPAGE="http://www.nongnu.org/util-vserver/"
SRC_URI="http://people.linux-vserver.org/~dhozac/t/uv-testing/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86"
IUSE="+dietlibc"

CDEPEND="
	net-misc/vconfig
	dev-libs/beecrypt
	sys-apps/iproute2
	net-firewall/iptables"

DEPEND="
	${CDEPEND}
	dietlibc? ( >dev-libs/dietlibc-0.33 )"

RDEPEND="
	${CDEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS=( README ChangeLog NEWS AUTHORS THANKS util-vserver.spec )

src_prepare() {
	if use dietlibc ; then
		eapply "${FILESDIR}/${P}-dietlibc.patch"
	fi
	eapply "${FILESDIR}/${PN}-init-functions.patch"
	eapply_user
}

pkg_setup() {
	if [[ -z "${VDIRBASE}" ]]; then
		einfo
		einfo "You can change the default vserver base directory (/vservers)"
		einfo "by setting the VDIRBASE environment variable."
	fi

	: ${VDIRBASE:=/vservers}

	einfo
	einfo "Using \"${VDIRBASE}\" as vserver base directory"
	einfo
}

src_test() {
	# do not use $D from portage by accident (#297982)
	sed -i -e 's/^\$D //' "${S}"/src/testsuite/vunify-test.sh || die

	default
}

src_configure() {
	local myeconf=" --with-vrootdir=${VDIRBASE} --with-initscripts=gentoo --localstatedir=/var"

	if ! use dietlibc ; then
		myeconf+=" --disable-dietlibc"
	fi
	
	econf ${myeconf} 
}

src_compile() {
	emake -j1
}

src_install() {
	make DESTDIR="${D}" install install-distribution || die

	# remove runtime paths
	rm -r "${D}"/var/run || die
	rm -r "${D}"/var/cache || die

	# keep dirs
	keepdir "${VDIRBASE}"
	keepdir "${VDIRBASE}"/.pkg

	# bash-completion
	newbashcomp "${FILESDIR}"/bash_completion ${PN}
}

pkg_postinst() {
	if ! use dietlibc ; then
		ewarn "dietlibc isn't just used to replace glibc, it is used to"
		ewarn "build static binaries which are actually 'static'"
		ewarn "note that glibc cannot build self contained binaries"
		ewarn "anymore, even if you build them 'statically' they will"
		ewarn "dynamically load resolver libraries, which in the case"
		ewarn "of guest management might be from the host or from the"
		ewarn "guest."
		ewarn "Anytime you start or enter the guest, you"
		ewarn "have a certain chance that the host will execute some"
		ewarn "code from the guest system (nss) which in turn gives"
		ewarn "guest root a good chance to do evil things on the host"
		ewarn "and even if security is not a concern in your case, you"
		ewarn "ight end up with unexpected failures"
		ewarn ""
		ewarn ""
	fi
	# Create VDIRBASE in postinst, so it is (a) not unmerged and (b) also
	# present when merging.
	mkdir -p "${VDIRBASE}" || die
	if ! setattr --barrier "${VDIRBASE}"; then
		ewarn "Filesystem on ${VDIRBASE} does not support chroot barriers."
		ewarn "Chroot barrier is additional security measure that is used"
		ewarn "when two vservers or the host system share the same filesystem."
		ewarn "If you intend to use separate filesystem for every vserver"
		ewarn "you can safely ignore this warning."
		ewarn "To manually apply a barrier use: setattr --barrier ${VDIRBASE}"
		ewarn "For details see: http://linux-vserver.org/Secure_chroot_Barrier"
	fi

	rm /etc/vservers/.defaults/vdirbase || die
	ln -sf "${VDIRBASE}" /etc/vservers/.defaults/vdirbase || die

	elog
	elog "You have to run the vprocunhide command after every reboot"
	elog "in order to setup /proc permissions correctly for vserver"
	elog "use. An init script has been installed by this package."
	elog "To use it you should add it to a runlevel:"
	elog
	elog " rc-update add vprocunhide default"
	elog
}
