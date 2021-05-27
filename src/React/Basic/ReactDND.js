"use strict";

const DND = require("react-dnd");

exports.dndProvider_ = DND.DndProvider;

exports.useDragLayer_ = () => {
  const {
    item,
    itemType,
    currentOffset,
    clientOffset,
    initialOffset,
    isDragging,
  } = DND.useDragLayer((monitor) => ({
    item: monitor.getItem(),
    itemType: monitor.getItemType(),
    currentOffset: monitor.getSourceClientOffset(),
    clientOffset: monitor.getClientOffset(),
    initialOffset: monitor.getInitialSourceClientOffset(),
    isDragging: monitor.isDragging(),
  }));

  const info =
    item && itemType && currentOffset && clientOffset && initialOffset
      ? { item, itemType, currentOffset, clientOffset, initialOffset }
      : null;
  return { info, isDragging };
};

exports.useDrag_ = (options) => {
  const [{ isDragging }, connectDrag, preview] = DND.useDrag({
    type: options.type,
    item: () => {
      if (options.item != null && options.item.id != null) {
        options.begin(options.item)();
        return options.item;
      }
    },
    collect: (monitor) => {
      const isDragging = monitor.isDragging();
      return { isDragging };
    },
    end: (item, monitor) => {
      if (item != null && item.id != null) {
        options.end(item)();
      }
    },
  });
  return { isDragging, connectDrag, preview };
};

exports.useDrop_ = (options) => {
  const [{ item, isOver }, connectDrop] = DND.useDrop({
    accept: options.accept,
    drop: (item) => {
      if (item != null && item.id != null) {
        options.onDrop(item)();
      }
    },
    collect: (monitor) => {
      const item = monitor.getItem();
      const isOver = monitor.isOver();
      return { item, isOver };
    },
  });
  return { item, isOver, connectDrop };
};

exports.mergeTargets = (ref1) => (ref2) => {
  // shhhhhhh, don't look 🙈
  // sometimes refs are React ref objects..
  // sometimes they're functions..
  // this allows ref1 and ref2 to each follow
  // either pattern, and the returned callback
  // to be used as a ref or function as well
  const cb = (next) => {
    if (ref1) ref1.current = next;
    if (ref2) ref2.current = next;
    if (typeof ref1 === "function") ref1(next);
    if (typeof ref2 === "function") ref2(next);
  };
  Object.defineProperty(cb, "current", {
    get() {
      return ref1.current;
    },
    set(next) {
      cb(next);
    },
  });
  return cb;
};
