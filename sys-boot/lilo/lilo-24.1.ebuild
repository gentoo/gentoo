# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit eutils flag-o-matic toolchain-funcs

DOLILO_V="0.6"
IUSE="static minimal pxeserial device-mapper"

DESCRIPTION="Standard Linux boot loader"
HOMEPAGE="https://alioth.debian.org/projects/lilo/"

DOLILO_TAR="dolilo-${DOLILO_V}.tar.bz2"
SRC_URI="
	http://lilo.alioth.debian.org/ftp/sources/${P}.tar.gz
	mirror://gentoo/${DOLILO_TAR}
"

SLOT="0"
LICENSE="BSD GPL-2"
KEYWORDS="-* ~amd64 ~x86"

DEPEND=">=sys-devel/bin86-0.15.5"
RDEPEND="device-mapper? ( >=sys-fs/lvm2-2.02.45 )"

src_prepare() {
	default

	# this patch is needed when booting PXE and the device you're using
	# emulates vga console via serial console.
	# IE..  B.B.o.o.o.o.t.t.i.i.n.n.g.g....l.l.i.i.n.n.u.u.x.x and stair stepping.
	use pxeserial && eapply "${FILESDIR}/${P}-novga.patch"

	eapply "${FILESDIR}/${PN}-24.x-fix-gcc-10.patch"

	# Do not strip and have parallel make
	# FIXME: images/Makefile does weird stuff
	sed -i Makefile src/Makefile \
		-e '/strip/d;s|^	make|	$(MAKE)|g' \
		-e '/images install/d' \
		-e '/images all/d' \
		|| die "sed strip failed"
}

src_configure() {
	if ! use device-mapper; then
		sed -i make.vars -e 's|-DDEVMAPPER||g' || die
	fi
}

src_compile() {
	# lilo needs this. bug #140209
	export LC_ALL=C

	# we explicitly prevent the custom CFLAGS for stability reasons
	if use static; then
		local target=alles
	else
		local target=all
	fi

	emake CC="$(tc-getCC) ${LDFLAGS}" ${target}
}

src_install() {
	keepdir /boot
	emake DESTDIR="${D}" install

	if use !minimal; then
		into /
		dosbin "${WORKDIR}"/dolilo/dolilo

		into /usr
		dosbin keytab-lilo.pl

		insinto /etc
		newins "${FILESDIR}"/lilo.conf lilo.conf.example

		newconfd "${WORKDIR}"/dolilo/dolilo.conf.d dolilo.example

		dodoc CHANGELOG* readme/README.* readme/INCOMPAT README
		docinto samples ; dodoc sample/*
	fi
}

# Check whether LILO is installed
# This function is from /usr/sbin/mkboot from debianutils, with copyright:
#
#   Debian GNU/Linux
#   Copyright 1996-1997 Guy Maor <maor@debian.org>
#
# Modified for Gentoo for use with the lilo ebuild by:
#   Martin Schlemmer <azarah@gentoo.org> (16 Mar 2003)
#
lilocheck() {
	local bootpart=
	local rootpart="$(mount | grep -v "tmpfs" | grep -v "rootfs" | grep "on / " | cut -f1 -d " ")"

	echo
	ebegin "Checking whether LILO can be safely updated"

	if [ "$(whoami)" != "root" ]
	then
		eend 1
		eerror "Only root can check for LILO"
		return 1
	fi

	if [ -z "${rootpart}" ]
	then
		eend 1
		eerror "Could not determine root partition"
		return 1
	fi

	if [ ! -f /etc/lilo.conf -o ! -x /sbin/lilo ]
	then
		eend 1
		eerror "No LILO configuration in place"
		return 1
	fi

	bootpart="$(sed -n "s:^boot[ ]*=[ ]*\(.*\)[ ]*:\1:p" /etc/lilo.conf)"

	if [ -z "${bootpart}" ]
	then
		# lilo defaults to current root when 'boot=' is not present
		bootpart="${rootpart}"
	fi

	if ! dd if=${bootpart} ibs=16 count=1 2>&- | grep -q 'LILO'
	then
		eend 1
		eerror "No LILO signature on ${bootpart}"
		ewarn "Check your /etc/lilo.conf, or run /sbin/lilo by hand."
		return 1
	fi

	if grep -q "^[[:space:]]*password[[:space:]]*=[[:space:]]*\"\"" /etc/lilo.conf
	then
		eend 1
		eerror "Interactive password entry configured"
		ewarn "Run /sbin/lilo -p by hand."
		return 1
	fi

	einfo "LILO on ${bootpart} is safe to update"
	eend 0
	return 0
}

pkg_postinst() {
	if [ ! -e "${ROOT}/boot/boot.b" -a ! -L "${ROOT}/boot/boot.b" ]
	then
		[ -f "${ROOT}/boot/boot-menu.b" ] && \
			ln -snf boot-menu.b "${ROOT}/boot/boot.b"
	fi

	if [ "${ROOT}" = "/" ] && use !minimal;
	then
		if lilocheck
		then
			einfo "Running DOLILO to complete the install"
			# do not redirect to /dev/null because it may display some input
			# prompt
			/sbin/dolilo
			if [ "$?" -ne 0 ]
			then
				eerror "You must manually configure and run LILO"
			fi
		fi
		echo
	fi
	if use !minimal; then
		echo
		einfo "Issue 'dolilo' instead of 'lilo' to have a friendly wrapper that"
		einfo "handles mounting and unmounting /boot for you. It can do more, "
		einfo "edit /etc/conf.d/dolilo to harness its full potential."
		echo
	fi
}
