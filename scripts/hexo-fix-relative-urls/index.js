hexo.extend.filter.register('post', function(data, callback) {
  data.content = data.content.replace(/\<a href="\//g, '<a href="http://www.osteele.com/');
  data.content = data.content.replace(/\<img src="\//g, '<img src="http://www.osteele.com/');
  // console.log('filtering', data.content);
  return callback(null, data);
});
