#
# Copyright: 2666680 Ontario Inc.
# Reason: Environment specific values.
#
import std/asyncnet
import std/options
import std/posix
import std/osproc

import hardware

type
  ArcContainer* = object  ## Container for an Arc Kernel.
    kernel*: string       ## The kernel name.
    state*: seq[string]   ## Additional state drives.
    initialSize*: int     ## Initial size of the kernel, in GBs.
    iso*: Option[string]  ## ISO file if we are creating a new file.
                          ## NOTE: Apps are removed for the moment, they
                          ##       will come into the system a bit later.

  ## MONAD: Creates a monad for commands
  CommandMonad* = object
    oldUid*: Uid
    rootUid*: Uid
    sudo*: bool

  VM* = object                    ## Running VM object.
    socket*: AsyncSocket          ## Connected QMP socket.
    lockFile*: string             ## Lock file path.
    socketDir*: string            ## Socket directory path.
    uuid*: string                 ## UUID for the VM.
    vfios*: seq[Vfio]             ## Normal VFIO devices.
    mdevs*: seq[Mdev]             ## VFIO-MDEV devices.
    introspections*: seq[string]  ## Introspections list.
    monad*: CommandMonad          ## Root monad to allow us to use root.
    qemuPid*: owned(Process)      ## PID for qemu.
    liveKernel*: string           ## Live Kernel name.
    baseKernel*: string           ## Base Kernel name.
    newInstall*: bool             ## New installation.
    save*: bool                   ## Do we save the VM.
    noCopy*: bool                 ## Do we copy the VM.
